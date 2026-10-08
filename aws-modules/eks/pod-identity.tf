resource "aws_eks_pod_identity_association" "pod_identity" {
  for_each = var.enable_pod_identity ? {
    for name, config in local.pod_identity :
    name => config
    if contains(keys(var.pod_identity_role_arns), name)
  } : {}
  cluster_name = aws_eks_cluster.eks.name
  role_arn        = var.pod_identity_role_arns[each.key]
  namespace       = each.value.namespace
  service_account = each.value.service_account
  depends_on = [ aws_eks_addon.eks_addons ]
}