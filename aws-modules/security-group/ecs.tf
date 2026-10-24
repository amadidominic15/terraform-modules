resource "aws_security_group" "ecs" {
  name_prefix = "${var.cluster_name}-ecs-sg"
  description = "Security group for ECS tasks"
  vpc_id      = var.vpc_id
  tags = {
    Name        = "${var.cluster_name}-ecs-sg"
    Environment = var.environment
  }
  lifecycle {
    create_before_destroy = true
  }
}

# Allow ECS application traffic only from the ALB.
resource "aws_vpc_security_group_ingress_rule" "ecs_from_alb" {
  for_each                     = toset(["3000", "3001"])
  security_group_id            = aws_security_group.ecs.id
  referenced_security_group_id = aws_security_group.alb_sg.id
  description                  = "Allow application traffic from ALB on port ${each.value}"
  ip_protocol                  = "tcp"
  from_port                    = tonumber(each.value)
  to_port                      = tonumber(each.value)
}

# Restrict this further when application dependencies and endpoints are known.
resource "aws_vpc_security_group_egress_rule" "ecs_egress" {
  security_group_id = aws_security_group.ecs.id
  description       = "Allow outbound connections from ECS tasks"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}