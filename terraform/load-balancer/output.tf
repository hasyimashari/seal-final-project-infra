output "load_balancer_dns_name" {
  value = aws_lb.main_alb.dns_name
}

output "target_group_arn" {
  value = [aws_lb_target_group.main_alb_target_group.arn]
}