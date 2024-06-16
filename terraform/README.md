# Terraform directory

this is where all the terraform code to provisioning aws infrastructure, this code created infra
- vpc (along with igw, nat gw, rtb-public, rtb-private, public-subnet, private-subnet)
- ec2
- rds
- load balancer(along with the target group)
- auto scaling group

### how to run

- initialize terraform code
```bash
terraform init
```

- check terraform code formating
```bash
terraform fmt
```

- validate the code
```bash
terraform validate
```

- create .tfvars file with content like this
```
db_username = "db_name"
db_password = "db_pw"
```

- check what resource will be create from the code
```bash
terraform plan -var-file=your-var-file-name.tfvars 
```

- creating resource
```bash
terraform apply -var-file=your-var-file-name.tfvars 
```

- deleting resource
```bash
terraform destroy -var-file=your-var-file-name.tfvars 
```