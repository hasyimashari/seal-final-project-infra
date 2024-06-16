# EC2 Instances
resource "aws_instance" "ec2_monitoring" {
  ami             = data.aws_ssm_parameter.amazon_linux2_ami_arm64.value
  instance_type   = "t4g.small"
  key_name        = "keysh"
  subnet_id       = var.public_sub_1_id
  security_groups = var.monitoring_sg_id
  user_data       = data.template_file.user_data_monitoring_server.rendered

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name    = "monitoring-server"
    Role    = "monitoring"
    Project = "Seal"
  }
}

resource "aws_instance" "ec2_web_server" {
  ami             = data.aws_ssm_parameter.amazon_linux2_ami_amd64.value
  instance_type   = "t2.small"
  key_name        = "keysh"
  subnet_id       = var.public_sub_1_id
  security_groups = var.web_server_sg_id
  user_data       = data.template_file.user_data_web_server.rendered

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name    = "web-server-teman-soal"
    Role    = "web-server"
    Project = "Seal"
  }
}