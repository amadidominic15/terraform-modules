#access for iam cluster user
resource "aws_eks_access_entry" "cluster_admins" {
  for_each      = var.admin_principal_arns
  cluster_name  = aws_eks_cluster.eks.name
  principal_arn = each.value
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "cluster_admins" {
  for_each      = var.admin_principal_arns
  cluster_name  = aws_eks_cluster.eks.name
  principal_arn = each.value
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  access_scope {
    type = "cluster"
  }
  depends_on = [aws_eks_access_entry.cluster_admins]
}

resource "aws_eks_access_entry" "karpenter_nodes" {
  cluster_name  = aws_eks_cluster.eks.name
  principal_arn = var.karpenter_node_role_arn
  type          = "EC2_LINUX"
}
