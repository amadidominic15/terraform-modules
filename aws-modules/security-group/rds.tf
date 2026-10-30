resource "aws_security_group" "rds" {
  count = var.create_rds_security_group ? 1 : 0
  name_prefix = "${var.name_prefix}-rds-"
  description = "Private RDS access from approved application workloads"
  vpc_id      = var.vpc_id
  tags = {
    Name = "${var.name_prefix}-rds-sg"
  }
  lifecycle {
    create_before_destroy = true
  }
}

# Allow PostgreSQL/MySQL access from EKS nodes when enabled
resource "aws_vpc_security_group_ingress_rule" "rds_from_eks_nodes" {
  for_each = (
    var.create_rds_security_group &&
    var.create_eks_security_group &&
    var.rds_allow_eks_nodes
  ) ? toset([for port in var.database_ports : tostring(port)]) : toset([])
  security_group_id            = aws_security_group.rds[0].id
  referenced_security_group_id = aws_security_group.eks_nodes[0].id
  description = "Allow database access from EKS nodes on port ${each.value}"
  ip_protocol = "tcp"
  from_port   = tonumber(each.value)
  to_port     = tonumber(each.value)
}

# Allow access from other explicitly supplied application security groups
resource "aws_vpc_security_group_ingress_rule" "rds_from_clients" {
  for_each = (
    var.create_rds_security_group
    ? {
        for pair in setproduct(
          var.database_client_security_group_ids,
          var.database_ports
        ) : "${pair[0]}-${pair[1]}" => {
          security_group_id = pair[0]
          port              = pair[1]
        }
      }
    : {}
  )

  security_group_id            = aws_security_group.rds[0].id
  referenced_security_group_id = each.value.security_group_id
  description = "Allow database access on port ${each.value.port}"
  ip_protocol = "tcp"
  from_port   = each.value.port
  to_port     = each.value.port
}