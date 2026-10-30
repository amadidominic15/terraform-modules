resource "aws_security_group" "vpc_endpoints" {
  count = var.create_vpc_endpoints_security_group ? 1 : 0
  name_prefix = "${var.name_prefix}-vpc-endpoints-"
  description = "Security group for VPC interface endpoints"
  vpc_id      = var.vpc_id
  tags = {
    Name = "${var.name_prefix}-vpc-endpoints"
  }
}

# Allow HTTPS from EKS nodes when explicitly enabled
resource "aws_vpc_security_group_ingress_rule" "vpc_endpoints_eks" {
  count = (
    var.create_vpc_endpoints_security_group &&
    var.vpc_endpoints_allow_eks_nodes &&
    var.create_eks_security_group
  ) ? 1 : 0
  security_group_id            = aws_security_group.vpc_endpoints[0].id
  referenced_security_group_id = aws_security_group.eks_nodes[0].id
  description = "Allow HTTPS from EKS worker nodes"
  ip_protocol = "tcp"
  from_port   = 443
  to_port     = 443
}

# Allow HTTPS from other explicitly supplied clients
resource "aws_vpc_security_group_ingress_rule" "vpc_endpoints_clients" {
  for_each = var.create_vpc_endpoints_security_group ? var.vpc_endpoint_client_security_group_ids : toset([])
  security_group_id            = aws_security_group.vpc_endpoints[0].id
  referenced_security_group_id = each.value
  description = "Allow HTTPS from approved workload security groups"
  ip_protocol = "tcp"
  from_port   = 443
  to_port     = 443
}

# Allow outbound traffic
resource "aws_vpc_security_group_egress_rule" "vpc_endpoints_all" {
  count = var.create_vpc_endpoints_security_group ? 1 : 0
  security_group_id = aws_security_group.vpc_endpoints[0].id
  description       = "Allow outbound traffic"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}