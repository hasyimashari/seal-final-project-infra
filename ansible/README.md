# Ansible directory

this is where all the ansible configuration neede to configuring ec2 instance for different purpose, the purpose for this final project ansible code is to configuring monitor server to install prometheus and grafana and to configure web server to update image and run conatiner with updated image

### how to run:

- check host
```bash
ansible-inventory --graph
```

- run playbook to configure monitor server
```bash
ansible-playbook ./playbooks/monitoring/main.yaml
```