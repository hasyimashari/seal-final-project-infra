# vpc module
module "vpc" {
  source = "./network"
}

# security group module
module "security_groups" {
  source = "./security group"

  vpc_id = module.vpc.vpc_id
}

# instance module
module "ec2" {
  source = "./instance"

  public_sub_1_id  = element(module.vpc.public_subnet_ids, 0)
  monitoring_sg_id = module.security_groups.ec2_monitoring_sg_id
  web_server_sg_id = module.security_groups.ec2_web_server_sg_id
}

# database module
module "rds" {
  source = "./database"

  db_username       = var.db_username
  db_password       = var.db_password
  private_sub_ids   = module.vpc.public_subnet_ids
  db_security_group = module.security_groups.rds_sg_id
}

# targert group ans load balancer
module "alb" {
  source = "./load-balancer"

  vpc_id            = module.vpc.vpc_id
  ec2_target_id     = module.ec2.ec2_web_server_id
  alb_sg_id         = module.security_groups.alb_sg_id
  public_subnet_ids = module.vpc.public_subnet_ids
}

# auto scaling group
module "asg" {
  source = "./auto-scaling"

  lt_sg                = module.security_groups.ec2_web_server_sg_id
  public_sub_ids       = module.vpc.public_subnet_ids
  alb_target_group_arn = module.alb.target_group_arn
}