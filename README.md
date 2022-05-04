# Ansible Network Demos

This repository houses some demonstration Ansible playbooks for network environments. These are not maintained and rely on Cisco's DevNet sandbox.

To execute a playbook run

```
ansible-playbook -i inventory.yml 4-port_config/main.yml
```

Where `4-port_config/main.yml` is the path to the playbook you want to run. Some playbooks will require `ansible-galaxy install ansible-network.network-engine` to be run prior to execution.
