resource "aws_security_group" "vpc_endpoints" {
  name        = "${var.cluster_name}-vpc-endpoints"
  description = "Security group for VPC interface endpoints."
  vpc_id      = var.vpc_id
  tags = {
    Name = "${var.cluster_name}-vpc-endpoints"
  }
}

resource "aws_vpc_security_group_ingress_rule" "vpc_endpoints_https" {
  security_group_id = aws_security_group.vpc_endpoints.id
  description = "Allow HTTPS from the VPC."
  ip_protocol = "tcp"
  from_port = 443
  to_port   = 443
  cidr_ipv4 = var.vpc_cidr
}

resource "aws_vpc_security_group_egress_rule" "vpc_endpoints_all" {
  security_group_id = aws_security_group.vpc_endpoints.id
  description = "Allow outbound traffic."
  ip_protocol = "-1"
  cidr_ipv4 = "0.0.0.0/0"
}