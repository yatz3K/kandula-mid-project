variable "aws_region" {
  default = "us-east-1"
  type    = string
}

variable "ami" {
    description = "default AMI for my project"
    type = string
    default = "ami-033b95fb8079dc481"
}