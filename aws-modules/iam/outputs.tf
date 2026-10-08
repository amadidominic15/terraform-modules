output "eks_cluster_role_arn" {
  description = "IAM role ARN used by the EKS control plane."
  value       = aws_iam_role.eks_cluster.arn
}

output "eks_node_role_arn" {
  description = "IAM role ARN used by EKS worker nodes."
  value       = aws_iam_role.eks_node.arn
}

output "pod_identity_role_arns" {
  description = "IAM role ARNs used by EKS Pod Identity."

  value = merge(
    var.enable_vpc_cni ? {
      vpc_cni = aws_iam_role.vpc_cni[0].arn
    } : {},

    var.enable_ebs_csi ? {
      ebs_csi = aws_iam_role.ebs_csi[0].arn
    } : {},

    var.enable_cloudwatch ? {
      cloudwatch = aws_iam_role.cloudwatch[0].arn
    } : {},

    var.enable_load_balancer_controller ? {
      load_balancer_controller = aws_iam_role.load_balancer_controller[0].arn
    } : {},

    var.enable_external_dns ? {
      external_dns = aws_iam_role.external_dns[0].arn
    } : {}
  )
}