#!/bin/sh
# Upgrade Ansible to use Python3
pip3 install ansible
# Clone netdevops-ansible-demos directory
git clone https://github.com/InsightSSG/netdevops-ansible-demos.git
# Install Ansible subcomponents
sudo yum -y install sshpass
pip3 install ansible-pylibssh
#
