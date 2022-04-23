variable "ansible_instance_type"{}

variable "ansible_ami" {}

variable "ansible_volumes_type" {}

variable "ansible_root_disk_size" {}

variable "vpc_id" {
  type = string
}

variable "public_subnets_id" {
  type = list(string)
}

variable "ansible_key" {}

variable "my_ip" {}