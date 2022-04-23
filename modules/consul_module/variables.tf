variable "consul_instance_type"{}

variable "consul_ami" {}

variable "consul_volumes_type" {}

variable "consul_root_disk_size" {}

variable "vpc_id" {
  type = string
}

variable "public_subnets_id" {
  type = list(string)
}

variable "consul_key" {}

variable "iam_role" {}

variable "my_ip" {}

variable "num_consul_server" {
  default = 3
}