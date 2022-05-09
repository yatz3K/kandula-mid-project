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
  private_key_file_name = var.private_key_file_name
  vpc_id = module.kandula_vpc.vpc_id
  public_subnets_id = module.kandula_vpc.public_subnets_id
  my_ip = ["${chomp(data.http.myip.body)}/32"]
  iam_role = aws_iam_instance_profile.ansible_server_ec2_fullaccess.name
  depends_on = [local_file.ec2_key, module.kandula_vpc]
}

module "consul_server" {
  source = "./modules/consul_module"
  consul_instance_type = var.instance_type
  consul_volumes_type = var.volume_type
  consul_root_disk_size = var.root_block_device_size
  consul_ami = var.ubuntu-ami
  consul_key = aws_key_pair.ec2_key.key_name
  vpc_id = module.kandula_vpc.vpc_id
  private_subnets_id = module.kandula_vpc.private_subnets_id
  public_subnets_id = module.kandula_vpc.public_subnets_id
  #my_ip = ["${chomp(data.http.myip.body)}/32"]
  iam_role = aws_iam_instance_profile.consul-join.name
  ansible_security_group = module.ansible_server.ansible_security_group_id
  depends_on = [module.ansible_server]
}