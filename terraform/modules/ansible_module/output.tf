output "ansible_server_public_adress" {
  value = aws_instance.ansible_server.public_ip
}

output "ansible_security_group_id" {
  value = aws_security_group.ansible_server_access.id
}