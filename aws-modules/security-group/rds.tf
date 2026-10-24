
resource "aws_security_group" "rds" {
  name_prefix = "${var.cluster_name}-rds-"
  description = "Private RDS access from EKS nodes"
  vpc_id      = var.vpc_id
  tags = {
    Name        = "${var.cluster_name}-rds-sg"
    Environment = var.environment
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_vpc_security_group_ingress_rule" "postgres_from_nodes" {
  security_group_id            = aws_security_group.rds.id
  referenced_security_group_id = aws_security_group.eks_nodes.id
  description                  = "PostgreSQL access from EKS nodes"
  ip_protocol                  = "tcp"
  from_port                    = 5432
  to_port                      = 5432
}

resource "aws_vpc_security_group_ingress_rule" "mysql_from_nodes" {
  security_group_id            = aws_security_group.rds.id
  referenced_security_group_id = aws_security_group.eks_nodes.id
  description                  = "mysql access from EKS nodes"
  ip_protocol                  = "tcp"
  from_port                    = 3306
  to_port                      = 3306
}

