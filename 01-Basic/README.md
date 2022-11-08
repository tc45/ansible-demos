# Basic Ansible NetDevOps

This lab assumes that you are using the Cisco DevNet Sandbox titled Cisco Modeling Labs (CML): Enterprise, 
although you can build this lab in your own environment using GNS3, CML, or Eve-NG.

This lab has two major sections: 
   
**Ad-hoc commands** - In this section we will look at using ansible directly from the CLI to execute
 commands using the RAW module (e.g. using SSH directly).  Multiple examples will be given to include showing commands, 
 parsing commands using grep, and outputting commands to text files.
 
**Simple playbooks** - This section will expand on the previous section by creating reusable playbooks which can be stored 
and shared for cross-team use.  Much more advanced functionality is allowed in a playbook but it comes with additional 
complexity. We will look at three Cisco modules in this section: cisco.ios.ios_commands, cisco.ios.ios_config, and 
cisco.ios.ios_facts.

NOTE: These steps are not intended to be used in a production network. They are only offered as a guide for 
practicing in a lab environment.  Consult with an ansible professional for using ansible in production environments.

## Prerequisites

#### sshpass

In this simple example we are going to have the DevBox prompt us for a password when accessing our inventory devices as 
opposed to storing them in either the inventory file or password vault.  in order to do this we must install **sshpass**
 onto the DevBox.  Enter the following command and follow prompts to install **sshpass**:
 
```
sudo yum install sshpass
```

### ansible-pylibssh

Install pylibssh library for Ansible.

```
pip3 install ansible-pylibssh
```

#### cisco.ios & cisco.nxos Modules

Some modules that Ansible uses do not come pre-installed.  These include two we are going to use, cisco.ios and cisco.nxos.  
From the command line on the DevBox type the following commands to install them.  We will use ansible-galaxy to install 
the collections using known good working versions of the modules.

```
ansible-galaxy collection install cisco.ios:==3.3.2
ansible-galaxy collection install cisco.nxos:==4.0.0
```

## Configuration and Inventory File

Change into the 01-Basic directory.
```
cd 01-Basic
```
Ansible will use the .cfg file located in this directory it was running from if present otherwise it will default to the 
file located in the /etc directory.  

For our simple example we only want to make sure that host_key_checking = False.  

The inventory file however must be specified. It is stored as a YAML file with the 
.yml extension.

Look at the contents of the simple inventory that is included.  This inventory file will reference all of the IOS devices
in the sandbox lab.  Type the cat command to get the output
```
cat inventory.yml
```

Output of **inventory.yml**
```
[devnet_ios]
10.10.20.175
10.10.20.176

[devnet_nxos]
10.10.20.177
10.10.20.178
```

Notice that each of the devices are located under a grouping for the device type.  .175 and .176 which are both IOS-XE devices 
are specfied as **devnet_ios** whereas .177 and .178 are specified as part of the **devnet_nxos** group.

## Ad-hoc commands
Ansible can be used directly from the CLI that it has been installed using the `ansible` command.  For full details on 
command line options see the documentation of run ```ansible --help```.  

### Run basic show commands using the RAW module
Ansible RAW module (ansible.builtin.raw) is a ansible-core module included in all Ansible installations.  Per the 
documentation it *Executes a low-down and dirty SSH command' on a device.  The primary use case is for devices that don't 
have Python installed which should include almost all network equipment.  

We will be using the [Ansible RAW Module](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/raw_module.html) 
in our first few examples from the CLI.   

#### Basic show commands
From the CLI of the DevBox run the following command.  The flags are as follows:

|Flag|Description|
|:---|:---|
|-m| Module used (using raw)|
|-a | Argument used |
| -u | Username |
| -k | prompt for password| 

Command structure for basic show commands
```
ansible <<hostname>> -m raw -a "<<command>>" -u <<username>> -k
```

1. Run a basic show command against a single device
    ```
    ansible 10.10.20.175 -m raw -a "show run" -u cisco -k
    ``` 

2. Change show command
    ```
    ansible 10.10.20.175 -m raw -a "show version" -u cisco -k
    ``` 

3. Run show command against inventory file
    - To run against the inventory file you must specify both the inventory file to be used as well as 
    the group you want to target.  The group **all** is a default group that includes all other groups.  
    ```
    ansible all -i inventory.yml -m raw -a "show version" -u cisco -k
    ```

4. Target group with show command in inventory file
    - Change the group **all** to group **devnet_ios**.
    ```
    ansible devnet_ios -i inventory.yml -m raw -a "show version" -u cisco -k
    ```
   
5. Extend ad-hoc commands with **grep**
   - Search for file version running by looking for specific output from 'show version' to capture for both IOS-XE and 
   NX-OS devices.  
   - Specify multiple search terms using ```\|``` to separate them.
   - NOTE: Added ```SUCCESS\|CHANGED\|``` to grep statement so we can see the line which shows the login status and hostname.
   ```
    ansible all -i inventory.yml -m raw -a "show version" -u cisco -k | grep 'SUCCESS\|CHANGED\|XE Software,\|NXOS image'
    ```
   
6. Extend ad-hoc commands with **grep**
   - Search for usernames in running by looking for specific output from 'show version' to capture for both IOS-XE and 
   NX-OS devices.  
   ```
    ansible all -i inventory.yml -m raw -a "show run" -u cisco -k | grep 'SUCCESS\|CHANGED\|username'
    ```

7. Send output to file.
   - Use LINUX command line to send output to a file.  GREP after file has been output
   ```
    ansible all -i inventory.yml -m raw -a "show run" -u cisco -k > show_run.txt
    ...
    <OUTPUT OMITTED>
    ...
    cat show_run.txt | grep 'username\|SUCCESS\|CHANGED'
   ```
   
8. Other non-privileged commands
   - Ping the same IP from multiple devices
   ```
    ansible all -i inventory.yml -m raw -a "ping 172.16.252.21" -u cisco -k
    ```
## Simple Playbooks - Beginning with cisco.ios.commands

Next step is to interact with Cisco devices much like we have, but using playbooks.  A playbook is a repeatable, re-usable 
config management/deployment file.  With [playbooks](https://docs.ansible.com/ansible/latest/user_guide/playbooks_intro.html) 
we can execute tasks, request command output, manipulate commands and more.  Ansible can use many modules from multiple 
vendors in playbooks but we will be using the [cisco.ios](https://docs.ansible.com/ansible/latest/collections/cisco/ios/index.html)
 module in our playbook.  Three basic modules exist for interacting with Cisco IOS devices, ios_command, ios_config, and ios_facts.

Playbooks are saved into the appropriate folders in this directory structure.  Review the playbook for complete syntax 
and execute using the commands listed below.

playbooks are executed using the following command structure:

```
ansible-playbook <<group_name>> -i <<inventory_file>> <<playbook_name>>
``` 

### ios_command 
 [ios_command](https://docs.ansible.com/ansible/latest/collections/cisco/ios/ios_command_module.html#ansible-collections-cisco-ios-ios-command-module)
  allows us to send arbitrary commands to the device and return results.  We can specify wait_for behavior to list conditions 
  before moving forward with a task.  This can be for a single line or other commands that require parent 
 configuration and then chid commands (e.g. acl name then acl entries). 
 
#### 01-run_show_version
Run a show version command on multiple devices

01-run_show_version/main.yml playbook text
```
---
- name: run show version on remote devices
  hosts: all
  gather_facts: no

  vars:
    ansible_connection: ansible.netcommon.network_cli
    ansible_network_os: cisco.ios.ios
    ansible_become: yes
    ansible_gecome_method: enable

  tasks:
    - name: run show version on remote devices
      cisco.ios.ios_command:
        commands: show version
```

Execute playbook
```
ansible-playbook -i inventory.yml 01-run_show_version/main.yml -u cisco -k
```

Notice when the playbook is ran we get to OKs from 10.10.20.175 and .176, but failed from .177 and .178.  This is due 
to the latter being NXOS devices however we specified the network_os and cisco.ios.  

To get around this, specify the group with the ```-l devnet_ios``` option being added to the command.

```
ansible-playbook -l devnet_ios -i inventory.yml 01-run_show_version/main.yml -u cisco -k
```

#### 02-run_show_arp

This playbook will get the 'show arp' info from all devices in the inventory file.

```


``` 


#### 03-run_show_mac_address_address-table

```

```

#### 04-save_multiple_commands_to_text
This playbook will save multiple commands to a text file using the ios_command modules.  Two versions have been created.  
The file main.yml is targetted to IOS devices.  The file main_nxos.yml is targeted to NXOS devices.



### ios_config
 
 

 
 ### ios_facts