module "kandula_vpc" {
  source = "./vpc_module"
  vpc_cidr_block = "192.168.0.0/16"
  private_subnet_list = ["192.168.10.0/24", "192.168.20.0/24"]
  public_subnet_list = ["192.168.100.0/24", "192.168.200.0/24"]
  aws_availability_zones = slice(data.aws_availability_zones.available.*.names[0], 0, 2)
}

module "ansible_server" {
  source = "./ansible_module"
  ansible_instance_type = "t2.micro"
  ansible_volumes_type = "gp2"
  ansible_root_disk_size = "10"
  ansible_ami = "ami-0c4f7023847b90238"
  ansible_key = aws_key_pair.ec2_key.key_name
  vpc_id = module.kandula_vpc.vpc_id
  public_subnets_id = module.kandula_vpc.public_subnets_id
  my_ip = ["${chomp(data.http.myip.body)}/32"]
  iam_role = aws_iam_instance_profile.ansible_server_ec2_fullaccess.name
}