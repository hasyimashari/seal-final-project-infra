output "ec2_monitoring_ip" {
  value = module.ec2.ec2_monitoring_server_ip
}

output "ec2_web_server_ip" {
  value = module.ec2.ec2_web_server_ip
}

output "alb_dns" {
  value = module.alb.load_balancer_dns_name
}

output "database_endpoint" {
  value = module.rds.db_instance_endpoint
}