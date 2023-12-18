# Ansible Network Demos

## Overview

This repository is intended to provide demos for Ansible network devices within the Cisco DevNet 
Sandbox. These are intended to illustrate common functionality available within the ansible 
ecosystem specific to network equipment. 

The lab uses Cisco DevNet Sandboxes as an underlying mechanism to quickly get the user in a lab environment that is generally available 
to all that provides the basic tools and test equipment necessary to immediately begin using Ansible for verification 
and configuration management.  Optionally the user can install their own LINUX box running Ansible to interact with any 
network devices.  Please be sure to test all commands in a lab environment before moving to production. 


## Structure 

The repository is broken up into Basic, Intermediary, and Advanced subdirectories with each one 
having their own unique instructions and playbooks. All subsections will use the same method of 
connectivity listed below.

- [**01-Basic**](https://github.com/InsightSSG/netdevops-ansible-demos/tree/main/01-Basic)
    - Ad-hoc commands
    - RAW Ansible module usage
    - Simple inventory
    - Simple playbooks
        - Registers and Debug
        - Variables
        - ios_command, ios_config, and ios_facts modules
- [**02-Intermediary**](https://github.com/InsightSSG/netdevops-ansible-demos/tree/main/02-Intermediary)
    - Structured static inventory files
    - Mature playbooks
        - Loops
        - Reuse variables
        - Functionally specific modules
- [**03-Advanced (FUTURE)**](https://github.com/InsightSSG/netdevops-ansible-demos/tree/main/03-Advanced)
    - Dynamic inventory
    - Complex playbooks
        - Chaining multiple plays
        - Advancing functionality using RAW python

## Getting started with Cisco DevNet Sandbox labs

All labs are intended to be used with the Cisco DevNet Sandbox lab titled 
Cisco Modeling Labs (CML): Enterprise v2.2.2. These labs change periodically change and as a result the 
instructions may need to be modified according to new scenarios.  The Cisco DevNet Sandbox gives 
a consistent user experience to these lab features regardless of the users available environment.  It provides 
a common topology using both IOS-XE and NX-OS devices.  

All devices in the sandbox can be accessed with either SSH or Telnet.  

NOTE: Ansible requires SSH for connectivity which is enabled by default on all of the IOS-XE and NX-OS devices.  

#### Topology
The topology for the lab consist of 4 network devices, 2 IOS-XE and 2 NX-OS devices.  Two additional hosts are available 
connected to each local network segment and a DevBox which is used for programmatic interaction with the devices.  
 
![Cisco DevNet Sandbox CML Topology (v2.2.2)](files/images/cisco_devnet_sandbox_cml_v2.2.2_topology.jpg)

#### Cisco DevNet Sandbox

Cisco DevNet Sandboxes can be accessed at the following URL:
[https://developer.cisco.com/sandbox](https://developer.cisco.com/sandbox)

- Locate the sandbox labeled: **Cisco Modeling Labs Enterprise** (Version 2.2.2 as of this update).
- Reserve lab (Recommend minimum of 4 hours.  Can be extended for up to 2 days)
- Wait for email instructions to login (takes 10-15 minutes)
- Login via Cisco AnyConnect VPN using instruction provided in the email
    - If you do not have AnyConnect, click on the **VPN Access** tab to download
- Access DevBox @ 10.10.20.50
- Review other device access on the **Network Devices** tab

NOTE: Only one active lab allowed at a time.  If lab does not load properly, in the sandbox UI you can choose to 'End Session' which will terminate connectivity and 
teardown devices.  Once torn down you can reschedule another session.

Optionally you may use a local machine capable of running Ansible (Linux systems, Mac, or Windows Subsystem for Linux).  
If you choose to do this make sure you have met the following requirements:

- Ansible v2.9+
- Python v3.8+
- Ansible-galaxy collections
    - ansible.network
    - cisco.ios:==3.3.2
    - cisco.nxos:==4.0.0

Once logged in you may continue with the lab.

### DevBox interaction

The sandbox provides us with the DevBox which is used for programmatic interaction with the network devices.  As of this 
writing, the DevBox is running CentOs with Python 3.6.8 and Ansible 2.9.  Login details via SSH for the DevBox are
 listed below.  

### Accessing DevBox
| Login via SSH ||
| ----------- | ----------- |
| **IP Address** | 10.10.20.50 |
| **Username** | developer |
| **Password** | C1sco12345 |


### First Use
Login using the IP and credentials above.  Once you are logged into the DevBox you should be placed into a Python Virtual Environment in the shell. 
```
(py3venv) [developer@devbox ~]$ ssh developer@10.10.20.50
Warning: Permanently added '10.10.20.50' (ECDSA) to the list of known hosts.
developer@10.10.20.50's password:
Last Login: Mon Aug 7 08:07:22 2022 from 192.168.254.11
(py3venv) [developer@devbox ~]$
```

Although the DevBox has Python v3.x on it, this instance is pointed to Python 2.7.5 instance.  This can be verified using 
the ```ansible --version``` command.  This will list both the ansible and python versions as well as the location of any 
configuration or executable files being used.  Hopefully this gets fixed soon but if python version < 3.x you will need 
to upgrade in order for this to work properly.  


### All of the pre-req steps can be completed using the following command
This will download a BASH script with commands to do the following:

- Install ansible using Python3
- Clone netdevops-ansible-demos repository
- Install sshpass
- Install ansible-pylibssh

```
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
```


```
curl https://raw.githubusercontent.com/InsightSSG/netdevops-ansible-demos/main/pre-req.sh | bash
```

### Manual Pre-Req installation
If you would prefer to install the applications manually, follow the [prerequisites](./PRE-REQS.md) instructions.



## Sub-section catalog

Labs are broken up into the following sub-sections.  Go to the README.md files in each of the directories to read further 
about how to use the labs.
  
- [01-Basic](https://github.com/InsightSSG/netdevops-ansible-demos/tree/main/01-Basic)
- [02-Intermediary](https://github.com/InsightSSG/netdevops-ansible-demos/tree/main/02-Intermediary)
- [03-Advanced](https://github.com/InsightSSG/netdevops-ansible-demos/tree/main/03-Advanced)

