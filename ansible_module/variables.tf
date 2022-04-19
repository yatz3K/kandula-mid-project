variable "ansible_instance_type"{}

variable "ami" {}

variable "ansible_volumes_type" {}

variable "ansible_root_disk_size" {}

data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}