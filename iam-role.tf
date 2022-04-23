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