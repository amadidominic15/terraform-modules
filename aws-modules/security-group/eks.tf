# ============================================================
# EKS CLUSTER SECURITY GROUP
# ============================================================

resource "aws_security_group" "eks_cluster" {
  count = var.create_eks_security_group ? 1 : 0
  name_prefix = "${var.name_prefix}-eks-cluster-"
  description = "Security group for EKS control plane"
  vpc_id      = var.vpc_id
  tags = {
    Name = "${var.name_prefix}-eks-cluster-sg"
  }
}

# ============================================================
# EKS NODE SECURITY GROUP
# ============================================================

resource "aws_security_group" "eks_nodes" {
  count = var.create_eks_security_group ? 1 : 0
  name_prefix = "${var.name_prefix}-eks-nodes-"
  description = "Security group for EKS worker nodes"
  vpc_id      = var.vpc_id
  tags = {
    Name                     = "${var.name_prefix}-eks-nodes-sg"
    "karpenter.sh/discovery" = "${var.name_prefix}-eks-cluster"
  }
}

# ============================================================
# CLUSTER INGRESS RULES
# ============================================================

# Nodes -> Cluster API
resource "aws_vpc_security_group_ingress_rule" "nodes_to_cluster_api" {
  count = var.create_eks_security_group ? 1 : 0
  security_group_id            = aws_security_group.eks_cluster[0].id
  referenced_security_group_id = aws_security_group.eks_nodes[0].id
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
  description = "Allow worker nodes to communicate with EKS API server"
}

# Cluster self traffic
resource "aws_vpc_security_group_ingress_rule" "cluster_self" {
  count = var.create_eks_security_group ? 1 : 0
  security_group_id            = aws_security_group.eks_cluster[0].id
  referenced_security_group_id = aws_security_group.eks_cluster[0].id
  ip_protocol = "-1"
  description = "Allow cluster internal traffic"
}

# ============================================================
# NODE INGRESS RULES
# ============================================================

# Cluster -> Nodes (kubelet)
resource "aws_vpc_security_group_ingress_rule" "cluster_to_nodes_kubelet" {
  count = var.create_eks_security_group ? 1 : 0
  security_group_id            = aws_security_group.eks_nodes[0].id
  referenced_security_group_id = aws_security_group.eks_cluster[0].id
  from_port   = 10250
  to_port     = 10250
  ip_protocol = "tcp"
  description = "Allow EKS control plane to communicate with kubelets"
}

# Cluster -> Nodes (HTTPS)
resource "aws_vpc_security_group_ingress_rule" "cluster_to_nodes_https" {
  count = var.create_eks_security_group ? 1 : 0
  security_group_id            = aws_security_group.eks_nodes[0].id
  referenced_security_group_id = aws_security_group.eks_cluster[0].id
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
  description = "Allow EKS control plane HTTPS traffic to nodes"
}

# Node <-> Node
resource "aws_vpc_security_group_ingress_rule" "nodes_to_nodes" {
  count = var.create_eks_security_group ? 1 : 0
  security_group_id            = aws_security_group.eks_nodes[0].id
  referenced_security_group_id = aws_security_group.eks_nodes[0].id
  ip_protocol = "-1"
  description = "Allow worker nodes to communicate with each other"
}

# ============================================================
# EGRESS RULES
# ============================================================

resource "aws_vpc_security_group_egress_rule" "cluster_all" {
  count = var.create_eks_security_group ? 1 : 0
  security_group_id = aws_security_group.eks_cluster[0].id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "Allow EKS control plane outbound traffic"
}

resource "aws_vpc_security_group_egress_rule" "nodes_all" {
  count = var.create_eks_security_group ? 1 : 0
  security_group_id = aws_security_group.eks_nodes[0].id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "Allow worker nodes outbound traffic"
}