module "kandula_vpc" {
  source = "./modules/vpc_module"
  vpc_cidr_block = "192.168.0.0/16"
  private_subnet_list = ["192.168.10.0/24", "192.168.20.0/24"]
  public_subnet_list = ["192.168.100.0/24", "192.168.200.0/24"]
  aws_availability_zones = slice(data.aws_availability_zones.available.*.names[0], 0, 2)
}

module "ansible_server" {
  source = "./modules/ansible_module"
  ansible_instance_type = var.instance_type
  ansible_volumes_type = var.volume_type
  ansible_root_disk_size = var.root_block_device_size
  ansible_ami = var.ubuntu-ami
  ansible_key = aws_key_pair.ec2_key.key_name
  vpc_id = module.kandula_vpc.vpc_id
  public_subnets_id = module.kandula_vpc.public_subnets_id
  my_ip = ["${chomp(data.http.myip.body)}/32"]
  iam_role = aws_iam_instance_profile.ansible_server_ec2_fullaccess.name
}

module "consul_server" {
  source = "./modules/consul_module"
  count = 3
  consul_instance_type = var.instance_type
  consul_volumes_type = var.volume_type
  consul_root_disk_size = var.root_block_device_size
  consul_ami = var.ubuntu-ami
  consul_key = aws_key_pair.ec2_key.key_name
  vpc_id = module.kandula_vpc.vpc_id
  public_subnets_id = element(module.kandula_vpc.public_subnets_id, count.index)
  my_ip = ["${chomp(data.http.myip.body)}/32"]
  iam_role = aws_iam_instance_profile.consul-join.name
}