# Create an IAM role for ansible server
resource "aws_iam_role" "ansible_server_ec2_fullaccess" {
    name = "ansible_server_ec2_fullaccess"
    assume_role_policy = file("policies/assume-role-ansible.json")
}

# Create the Policy
resource "aws_iam_policy" "ansible_server_ec2_fullaccess" {
  name = "ansible_server_ec2_fullaccess"
  description = "Allows ansible server full access to EC2 instances"
  policy = file("policies/ansible-access.json")
}

# Attach the policy
resource "aws_iam_policy_attachment" "ansible_server_ec2_fullaccess" {
  name = "ansible_server_ec2_fullaccess"
  roles = [aws_iam_role.ansible_server_ec2_fullaccess.name]
  policy_arn = aws_iam_policy.ansible_server_ec2_fullaccess.arn
}

# Create the instance profile
resource "aws_iam_instance_profile" "ansible_server_ec2_fullaccess" {
  name = "ansible_server_ec2_fullaccess"
  role = aws_iam_role.ansible_server_ec2_fullaccess.name
}

################################

# Create an IAM role for the auto-join
resource "aws_iam_role" "consul-join" {
  name               = "kandula-consul-join"
  assume_role_policy = file("policies/assume-role-consul.json")
}

# Create the policy
resource "aws_iam_policy" "consul-join" {
  name        = "kandula-consul-join"
  description = "Allows Consul nodes to describe instances for joining."
  policy      = file("policies/describe-instances-consul.json")
}

# Attach the policy
resource "aws_iam_policy_attachment" "consul-join" {
  name       = "ops-consul-join"
  roles      = [aws_iam_role.consul-join.name]
  policy_arn = aws_iam_policy.consul-join.arn
}

# Create the instance profile
resource "aws_iam_instance_profile" "consul-join" {
  name  = "ops-consul-join"
  role = aws_iam_role.consul-join.name
}

###################################

module "iam_assumable_role_admin" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "~> 4.7.0"
  create_role                   = true
  role_name                     = "kandula-k8s-role"
  provider_url                  = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = ["arn:aws:iam::aws:policy/AmazonEC2FullAccess"]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${local.k8s_service_account_namespace}:${local.k8s_service_account_name}"]
}