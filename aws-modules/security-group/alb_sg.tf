resource "aws_security_group" "alb_sg" {
  count       = var.create_alb_security_group ? 1 : 0
  name_prefix = "${var.name_prefix}-alb-"
  description = "Security group for the public Application Load Balancer"
  vpc_id      = var.vpc_id
  tags = {
    Name = "${var.name_prefix}-alb-sg"
  }
  lifecycle {
    create_before_destroy = true
  }
}

# Allow HTTP traffic
resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  for_each          = var.create_alb_security_group ? toset(var.alb_ingress_cidrs) : toset([])
  security_group_id = aws_security_group.alb_sg[0].id
  description       = "Allow HTTP from approved CIDRs"
  cidr_ipv4         = each.value
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
}

# Allow HTTPS traffic
resource "aws_vpc_security_group_ingress_rule" "alb_https" {
  for_each          = var.create_alb_security_group ? toset(var.alb_ingress_cidrs) : toset([])
  security_group_id = aws_security_group.alb_sg[0].id
  description       = "Allow HTTPS from approved CIDRs"
  cidr_ipv4         = each.value
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
}

# Allow outbound traffic
resource "aws_vpc_security_group_egress_rule" "alb_all" {
  count             = var.create_alb_security_group ? 1 : 0
  security_group_id = aws_security_group.alb_sg[0].id
  description       = "Allow outbound traffic from ALB"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}