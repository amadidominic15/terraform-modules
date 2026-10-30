resource "aws_security_group" "ecs" {
  count       = var.create_ecs_security_group ? 1 : 0
  name_prefix = "${var.name_prefix}-ecs-"
  description = "Allow application traffic from the ALB only"
  vpc_id      = var.vpc_id
  tags = {
    Name = "${var.name_prefix}-ecs-sg"
  }
}

# Allow ECS application traffic only from the ALB
resource "aws_vpc_security_group_ingress_rule" "ecs_from_alb" {
  for_each = (
    var.create_ecs_security_group && var.create_alb_security_group
    ? { for port in var.application_ports : tostring(port) => port }
    : {}
  )
  security_group_id            = aws_security_group.ecs[0].id
  referenced_security_group_id = aws_security_group.alb_sg[0].id
  description                  = "Allow application traffic from ALB on port ${each.value}"
  ip_protocol                  = "tcp"
  from_port                    = each.value
  to_port                      = each.value
}

# Allow outbound connections
resource "aws_vpc_security_group_egress_rule" "ecs_egress" {
  count             = var.create_ecs_security_group ? 1 : 0
  security_group_id = aws_security_group.ecs[0].id
  description       = "Allow outbound connections from ECS tasks"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}