## Prerequisites

## Force Ansible to use Python3

The easiest way to force Ansible to use Python3 is to install Ansible using pip3 in the 
virtual environment.

```
pip3 install ansible
``` 
Once ansible has been installed again, logout and back into the session.  Run the command ```ansible --version``` again 
and you should see the version updated to 3.6.8 (Latest releast for CentOS7).  

```
(py3venv) [developer@devbox ~]$ ansible --version
ansible 2.10.7
  config file = None
  configured module search path = ['/home/developer/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /home/developer/py3venv/lib/python3.6/site-packages/ansible
  executable location = /home/developer/py3venv/bin/ansible
  python version = 3.6.8 (default, Sep 14 2019, 14:33:46) [GCC 4.8.5 20150623 (Red Hat 4.8.5-36)]
(py3venv) [developer@devbox ~]$ 
```

## Clone Repository

Clone this repository from the command line in the home directory of the DevBox using ```git```.

```
git clone https://github.com/InsightSSG/netdevops-ansible-demos.git
```

This command will reach out to github and copy the main branch of this repository to a local directory called 
*netdevops-ansible-demos*.  Once downloaded, ```cd netdevops-ansible-demos``` to continue.

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