#! /bin/bash
sudo hostnamectl set-hostname ansible-server
sudo apt-get update
sudo apt-get install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt-get install ansible -y
sudo apt-get-install git -y
sudo apt-get install python3 -y
sudo apt-get install python3-pip -y
sudo pip3 install boto3
ansible-galaxy collection install amazon.aws
chmod 400 /home/ubuntu/.ssh/id_rsa
cat /home/ubuntu/.ssh/authorized_keys >> /home/ubuntu/.ssh/id_rsa.pub
mkdir -p /home/ubuntu/ansible
git clone https://github.com/yatz3K/kandula-mid-project.git /home/ubuntu/ansible