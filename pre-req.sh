#!/bin/sh
# Upgrade Ansible to use Python3
pip3 install ansible
# Clone netdevops-ansible-demos directory
git clone https://github.com/InsightSSG/netdevops-ansible-demos.git
# Install Ansible subcomponents
sudo yum -y install sshpass
pip3 install ansible-pylibssh
# Install Ansible-galaxy collections
ansible-galaxy collection install cisco.ios:==3.3.2
ansible-galaxy collection install cisco.nxos:==4.0.0
# Install tree (view directory structure)
sudo yum -y install tree
cd netdevops-ansible-demos
git clone https://github.com/networktocode/ntc-templates.git
pip3 install textfsm --upgrade