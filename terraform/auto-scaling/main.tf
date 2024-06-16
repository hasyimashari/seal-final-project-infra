# Launch Template
resource "aws_launch_template" "ec2_web_server_lt" {
  name_prefix   = "web-server-teman-soal-template"
  image_id      = data.aws_ssm_parameter.amazon_linux2_ami_amd64.value
  instance_type = "t2.small"
  key_name      = "keysh"
  user_data     = base64encode(data.template_file.user_data_web_server.rendered)

  network_interfaces {
    security_groups = var.lt_sg
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 20
      volume_type = "gp3"
    }
  }

  tags = {
    Name = "web-server-teman-soal-template"
    Project = "Seal"
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "main_asg" {
  desired_capacity     = 1
  max_size             = 3
  min_size             = 1
  vpc_zone_identifier  = var.public_sub_ids

  launch_template {
    id      = aws_launch_template.ec2_web_server_lt.id
    version = "$Latest"
  }

  target_group_arns = var.alb_target_group_arn

  tag {
    key                 = "Name"
    value               = "asg-web-server-teman-soal"
    propagate_at_launch = true
  }

  tag {
    key                 = "Role"
    value               = "web-server"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_policy" "scale_out" {
  name                   = "scale-out"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.main_asg.name
}

resource "aws_autoscaling_policy" "scale_in" {
  name                   = "scale-in"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.main_asg.name
}

resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name                = "high-cpu"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "70"
  alarm_description         = "This metric monitors CPU utilization"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.main_asg.name
  }

  alarm_actions             = [aws_autoscaling_policy.scale_out.arn]
  ok_actions                = []
  insufficient_data_actions = []
}

resource "aws_cloudwatch_metric_alarm" "low_cpu" {
  alarm_name                = "low-cpu"
  comparison_operator       = "LessThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "30"
  alarm_description         = "This metric monitors CPU utilization"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.main_asg.name
  }

  alarm_actions             = [aws_autoscaling_policy.scale_in.arn]
  ok_actions                = []
  insufficient_data_actions = []
}