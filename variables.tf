variable "aws_region" {
  default = "us-east-1"
  type    = string
}

variable "instance_type" {
  description = "The type of the ec2, for example - t2.medium"
  type        = string
  default     = "t2.micro"
}

variable "ami" {
    description = "default AMI for my project"
    type = string
    default = "ami-033b95fb8079dc481"
}

variable "ansible_volumes_type" {
  description = "volume type for ansible server"
  type = string
  default = "gp2"
}

variable "ansible_root_disk_size" {
  description = "root disk size"
  default = "10"
}