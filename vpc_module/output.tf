output "vpc_id" {
  value = aws_vpc.kandula_vpc.id
}

output "public_subnets_id" {
  value = aws_subnet.public.*.id
}

output "private_subnets_id" {
  value = aws_subnet.private.*.id
}

output "vpc_cider" {
  value = aws_vpc.kandula_vpc.cidr_block
}