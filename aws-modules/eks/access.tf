resource "aws_eks_access_entry" "admins" {
  for_each = var.admin_principal_arns
  cluster_name  = aws_eks_cluster.eks.name
  principal_arn = each.value
  type = "STANDARD"
}

resource "aws_eks_access_policy_association" "admins" {
  for_each = var.admin_principal_arns
  cluster_name  = aws_eks_cluster.eks.name
  principal_arn = each.value
  policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  access_scope {
    type = "cluster"
  }
  depends_on = [ aws_eks_access_entry.admins ]
}