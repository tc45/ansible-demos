# Basic Ansible NetDevOps

This lab assumes that you are using the Cisco DevNet Sandbox titled Cisco Modeling Labs (CML): Enterprise, 
although you can build this lab in your own environment using GNS3, CML, or Eve-NG.

This lab has three sections:    
- Ad-hoc commands (Using Ansible without playbooks)
- RAW playbooks and ios_commands module
- CLI playbooks

## Inventory and Configuration File
Ansible will use the .cfg file located in the directory it was running from if present otherwise it will default to the 
file located in the /etc directory.  The inventory file however must be specified. 


## Ad-hoc commands (Using Ansible without playbooks)
Ansible can be used directly from the CLI that it has been installed using the `ansible` command.  
There are many possible 


