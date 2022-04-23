output "ansible_server_public_adress" {
  value = aws_instance.ansible_server.*.public_ip
}