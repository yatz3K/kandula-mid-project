resource "aws_instance" "ansible_server" {
  ami = var.ansible_ami
  instance_type = var.ansible_instance_type
  key_name = var.ansible_key
  subnet_id = var.public_subnets_id[0]
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.ansible_server_access.id]
  iam_instance_profile = var.iam_role
  user_data = file("ansible_module/ansible_server_userdata.tpl")
  
  root_block_device {
    encrypted = false
    volume_type = var.ansible_volumes_type
    volume_size = var.ansible_root_disk_size
  }

 tags = {
     "Name" = "kandula_ansible_server"
 }
}

resource "aws_security_group" "ansible_server_access" {
  vpc_id = var.vpc_id
  name = "ansible access"

  tags = {
      "Name" = "ansible-access-${var.vpc_id}"
  }
}

resource "aws_security_group_rule" "ansible_ssh_access" {
    description = "access to ansible via ssh"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_group_id = aws_security_group.ansible_server_access.id
    type = "ingress"
    cidr_blocks = var.my_ip
}

resource "aws_security_group_rule" "outbound_anywhere" {
  description = "allow outbound traffic to anywhere"
  from_port = 0
  to_port = 0
  protocol = "-1"
  security_group_id = aws_security_group.ansible_server_access.id
  type = "egress"
  cidr_blocks = ["0.0.0.0/0"]
  
}