# ============================================================
# EKS CLUSTER SECURITY GROUP
# ============================================================
resource "aws_security_group" "eks_cluster" {
  name        = "${var.cluster_name}-cluster-sg"
  description = "Security group for EKS control plane"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.cluster_name}-cluster-sg"
  }
}

# ============================================================
# EKS NODE SECURITY GROUP
# ============================================================
resource "aws_security_group" "eks_nodes" {
  name        = "${var.cluster_name}-nodes-sg"
  description = "Security group for EKS worker nodes"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.cluster_name}-nodes-sg"
  }
}

# ============================================================
# CLUSTER INGRESS RULES
# ============================================================

# Nodes → Cluster API (HTTPS)
resource "aws_vpc_security_group_ingress_rule" "nodes_to_cluster_api" {
  security_group_id            = aws_security_group.eks_cluster.id
  referenced_security_group_id = aws_security_group.eks_nodes.id
  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "tcp"
  description                  = "Allow worker nodes to communicate with EKS API server"
}

# Cluster self traffic (control plane internal)
resource "aws_vpc_security_group_ingress_rule" "cluster_self" {
  security_group_id            = aws_security_group.eks_cluster.id
  referenced_security_group_id = aws_security_group.eks_cluster.id
  ip_protocol                  = "-1"
  description                  = "Allow cluster internal traffic"
}

# ============================================================
# NODE INGRESS RULES
# ============================================================

# Cluster → Nodes (kubelet)
resource "aws_vpc_security_group_ingress_rule" "cluster_to_nodes_kubelet" {
  security_group_id            = aws_security_group.eks_nodes.id
  referenced_security_group_id = aws_security_group.eks_cluster.id
  from_port                    = 10250
  to_port                      = 10250
  ip_protocol                  = "tcp"
  description                  = "Allow EKS control plane to communicate with kubelets"
}

# Cluster → Nodes (HTTPS / metrics, etc.)
resource "aws_vpc_security_group_ingress_rule" "cluster_to_nodes_https" {
  security_group_id            = aws_security_group.eks_nodes.id
  referenced_security_group_id = aws_security_group.eks_cluster.id
  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "tcp"
  description                  = "Allow EKS control plane HTTPS traffic to nodes"
}

# Node ↔ Node traffic
resource "aws_vpc_security_group_ingress_rule" "nodes_to_nodes" {
  security_group_id            = aws_security_group.eks_nodes.id
  referenced_security_group_id = aws_security_group.eks_nodes.id
  ip_protocol                  = "-1"
  description                  = "Allow worker nodes to communicate with each other"
}

# ============================================================
# EGRESS RULES
# ============================================================

resource "aws_vpc_security_group_egress_rule" "cluster_all" {
  security_group_id = aws_security_group.eks_cluster.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "Allow EKS control plane outbound traffic"
}

resource "aws_vpc_security_group_egress_rule" "nodes_all" {
  security_group_id = aws_security_group.eks_nodes.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "Allow worker nodes outbound traffic"
}