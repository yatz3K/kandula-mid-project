variable "aws_region" {
  default = "us-east-1"
  type    = string
}

variable "ubuntu-ami" {
  type = string
  default = "ami-0c4f7023847b90238"
}

variable "instance_type" {
  type = string
  default = "t2.micro"
}

variable "volume_type" {
  type = string
  default = "gp2"
}

variable "root_block_device_size" {
  type = string
  default = "10"
}

variable "num_consul_server" {
  default = 3
}