output "alb_arn" {
  value = aws_lb.alb.arn
}

output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}

output "target_group_arns" {
  value = {
    for key, target_group in aws_lb_target_group.alb :
    key => target_group.arn
  }
}