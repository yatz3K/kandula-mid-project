output "id" {
  value = aws_instance.consul_server.*.id
}