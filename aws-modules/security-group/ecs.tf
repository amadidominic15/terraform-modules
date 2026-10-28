resource "aws_security_group" "ecs" {
  name        = "${var.name_prefix}-ecs-sg"
  description = "Allow application traffic from the ALB only"
  vpc_id      = var.vpc_id
  tags = {
    Name = "${var.name_prefix}-ecs-sg"
  }
}

# Allow ECS application traffic only from the ALB.
resource "aws_vpc_security_group_ingress_rule" "ecs_from_alb" {
  for_each                     = { for port in var.application_ports : tostring(port) => port }
  security_group_id            = aws_security_group.ecs.id
  referenced_security_group_id = aws_security_group.alb_sg.id
  description                  = "Allow application traffic from ALB on port ${each.value}"
  ip_protocol                  = "tcp"
  from_port                    = each.value
  to_port                      = each.value
}

# Restrict this further when application dependencies and endpoints are known.
resource "aws_vpc_security_group_egress_rule" "ecs_egress" {
  security_group_id = aws_security_group.ecs.id
  description       = "Allow outbound connections from ECS tasks"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}