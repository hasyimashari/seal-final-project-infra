output "ec2_monitoring_server_ip" {
  value = [aws_instance.ec2_monitoring.public_ip]
}

output "ec2_web_server_id" {
  value = aws_instance.ec2_web_server.id
}

output "ec2_web_server_ip" {
  value = [aws_instance.ec2_web_server.public_ip]
}