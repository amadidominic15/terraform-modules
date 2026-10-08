resource "aws_eks_addon" "eks_addons" {
  for_each = var.addons
  cluster_name = aws_eks_cluster.eks.name
  addon_name   = each.key
  addon_version = data.aws_eks_addon_version.eks_addons[each.key].version
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
  depends_on = [ aws_eks_node_group.node_group ]
}