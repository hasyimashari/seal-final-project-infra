output "ec2_monitoring_sg_id" {
  value = [aws_security_group.ec2_monitoring_sg.id]
}

output "ec2_web_server_sg_id" {
  value = [aws_security_group.ec2_web_server_sg.id]
}

output "rds_sg_id" {
  value = [aws_security_group.rds_sg.id]
}

output "alb_sg_id" {
  value = [aws_security_group.alb_sg.id]
}