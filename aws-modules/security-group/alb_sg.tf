# ALB security group - public facing
resource "aws_security_group" "alb_sg" {
  name_prefix = "${var.cluster_name}-alb-sg-"
  description = "Allow inbound HTTP/HTTPS traffic to the ALB"
  vpc_id      = var.vpc_id
}

# Allow public HTTP traffic to the ALB.
resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.alb_sg.id
  description       = "Allow HTTP traffic from the internet"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_ipv4         = "0.0.0.0/0"
}

# Allow public HTTPS traffic to the ALB.
resource "aws_vpc_security_group_ingress_rule" "alb_https" {
  security_group_id = aws_security_group.alb_sg.id
  description       = "Allow HTTPS traffic from the internet"
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_ipv4         = "0.0.0.0/0"
}

# Allow the ALB to forward traffic to ECS tasks.
resource "aws_vpc_security_group_egress_rule" "alb_to_ecs" {
  security_group_id            = aws_security_group.alb_sg.id
  referenced_security_group_id = aws_security_group.ecs.id
  description                  = "Allow traffic to ECS application port"
  ip_protocol                  = "tcp"
  from_port                    = 3000
  to_port                      = 3000

}