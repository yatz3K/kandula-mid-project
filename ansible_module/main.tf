resource "aws_instance" "ansible_server" {
  instance_type = var.ansible_instance_type
  key_name = ""
  subnet_id = module.vpc_module.public_subnets_id[0]
  associate_public_ip_address = true
  vpc_security_group_ids = ""
  user_data = ""
  
  root_block_device {
    encrypted = false
    volume_type = var.ansible_volumes_type
    volume_size = var.ansible_root_disk_size
  }

 tags = {
     "Name" = "kandula_ansible_server-${regex(".$", data.aws_availability_zones.available.names[count.index])}"
 }
}

resource "aws_security_group" "ansible_server_access" {
  vpc_id = module.vpc_module.vpc_id
  name = "ansible access"

  tags = {
      "Name" = "ansible-access-${moudle.vpc_module.vpc_id}"
  }
}

resource "aws_security_group_rule" "ansible_ssh_access" {
    description = "access to ansible via ssh"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_group_id = aws_security_group.ansible_server_access.id
    type = "ingress"
    cidr_blocks = ["${chomp(var.http.myip.body)}/32"]
}