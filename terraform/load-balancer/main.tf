# Target Group
resource "aws_lb_target_group" "main_alb_target_group" {
  name     = "seal-ec2-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    interval            = 30
    path                = "/"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    protocol            = "HTTP"
  }

  tags = {
    Name = "seal-ec2-target-group"
    Project = "Seal"
  }
}

# Register EC2 Instances with Target Group
resource "aws_lb_target_group_attachment" "instance" {
  target_group_arn = aws_lb_target_group.main_alb_target_group.arn
  target_id        = var.ec2_target_id
  port             = 80
}


# Load Balancer
resource "aws_lb" "main_alb" {
  name               = "seal-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.alb_sg_id
  subnets            = var.public_subnet_ids

  tags = {
    Name = "seal-load-balancer"
    Project = "Seal"
  }
}

# Load Balancer Listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main_alb_target_group.arn
  }
}