output "cluster_id" {
  description = "EKS cluster ID"
  value       = aws_eks_cluster.eks.id
}

output "cluster_name" {
  description = "EKS cluster name"
  value       = aws_eks_cluster.eks.name
}

output "cluster_endpoint" {
  description = "EKS Kubernetes API endpoint"
  value       = aws_eks_cluster.eks.endpoint
}

output "cluster_certificate_authority_data" {
  description = "EKS cluster CA data"
  value       = aws_eks_cluster.eks.certificate_authority[0].data
  sensitive   = true
}

output "cluster_security_group_id" {
  description = "EKS cluster security group ID"
  value       = aws_eks_cluster.eks.vpc_config[0].cluster_security_group_id
}

output "oidc_issuer_url" {
  description = "EKS OIDC issuer URL"
  value       = aws_eks_cluster.eks.identity[0].oidc[0].issuer
}

output "node_group_id" {
  description = "EKS managed node group ID"
  value       = aws_eks_node_group.node_group.id
}

output "node_group_arn" {
  description = "EKS managed node group ARN"
  value       = aws_eks_node_group.node_group.arn
}