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

resource "aws_vpc_security_group_ingress_rule" "ecs_from_alb" {
  security_group_id            = aws_security_group.ecs.id
  referenced_security_group_id = aws_security_group.alb_sg.id
  description                  = "Allow application traffic from the ALB"
  ip_protocol                  = "tcp"
  from_port                    = 3000
  to_port                      = 3000

}



resource "aws_vpc_security_group_egress_rule" "ecs_egress" {
  security_group_id = aws_security_group.ecs.id
  description       = "Allow outbound connections from ECS tasks"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}