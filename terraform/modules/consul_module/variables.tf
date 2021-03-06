variable "consul_instance_type"{}

variable "consul_ami" {}

variable "consul_volumes_type" {}

variable "consul_root_disk_size" {}

variable "vpc_id" {
  type = string
}

variable "public_subnets_id" {}

variable "private_subnets_id" {}

variable "consul_key" {}

variable "iam_role" {}

variable "num_consul_server" {
  default = 3
}

variable "ansible_security_group" {}

variable "Purpose" {
  type = string
  default = "Consul"
}