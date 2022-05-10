resource "aws_instance" "consul_server" {
    count = var.num_consul_server
    ami = var.consul_ami
    instance_type = var.consul_instance_type
    key_name = var.consul_key
    subnet_id = element(var.private_subnets_id, count.index)
    vpc_security_group_ids = [aws_security_group.consul_server_access.id]
    iam_instance_profile = var.iam_role
    user_data = <<EOF
                  #!/bin/bash
                  sudo hostnamectl set-hostname server-${count.index+1}
                  EOF
  
  root_block_device {
    encrypted = false
    volume_type = var.consul_volumes_type
    volume_size = var.consul_root_disk_size
  }

 tags = {
     "Name" = "kandula_consul_server-${count.index+1}"
     "Purpose" = var.Purpose
 }
}

resource "aws_security_group" "consul_server_access" {
  vpc_id = var.vpc_id
  name = "consul access"

  tags = {
      "Name" = "consul-access-${var.vpc_id}"
  }
}

resource "aws_security_group_rule" "consul_ssh_access" {
    description = "access to consul from ansible server"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_group_id = aws_security_group.consul_server_access.id
    type = "ingress"
    source_security_group_id = var.ansible_security_group
}

resource "aws_security_group_rule" "consul_UI_access" {
  description = "access to consul UI from my IP"
  from_port = 8500
  to_port = 8500
  protocol = "tcp"
  type = "ingress"
  security_group_id = aws_security_group.consul_server_access.id
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "outbound_anywhere" {
  description = "allow outbound traffic to anywhere"
  from_port = 0
  to_port = 0
  protocol = "-1"
  security_group_id = aws_security_group.consul_server_access.id
  type = "egress"
  cidr_blocks = ["0.0.0.0/0"]
}

  resource "aws_security_group_rule" "all_inside_security_group" {
    description = "Allow all inside security group"
    security_group_id = aws_security_group.consul_server_access.id
    from_port = 0
    to_port = 0
    protocol = "-1"
    type = "ingress"
    self = true
  }