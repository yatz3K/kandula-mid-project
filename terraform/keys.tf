resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ec2_key" {
  key_name   = "ec2_key_kandula"
  public_key = tls_private_key.ec2_key.public_key_openssh
}

resource "local_file" "ec2_key" {
  sensitive_content  = tls_private_key.ec2_key.private_key_pem
  filename           = "ec2_key_kandula.pem"
}