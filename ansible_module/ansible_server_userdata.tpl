#! /bin/bash
sudo hostnamectl set-hostname ansible-server
sudo apt update
sudo apt install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible -y
sudo apt-get-install git -y
sudo apt-get install python3 -y
sudo apt-get install python3-pip -y
sudo pip3 install boto3
mkdir -p /home/ubuntu/ansible
git clone 