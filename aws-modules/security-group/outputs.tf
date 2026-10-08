output "cluster_security_group_id" {
  description = "ID of the EKS cluster security group"
  value       = aws_security_group.eks_cluster.id
}
output "nodes_security_group_id" {
  description = "ID of the EKS nodes security group"
  value       = aws_security_group.eks_nodes.id
}
output "cluster_security_group_arn" {
  description = "ARN of the EKS cluster security group"
  value       = aws_security_group.eks_cluster.arn
}
output "nodes_security_group_arn" {
  description = "ARN of the EKS nodes security group"
  value       = aws_security_group.eks_nodes.arn
}
output "vpc_endpoint_security_group_id" {
  description = "Security group ID used by VPC interface endpoints."
  value = aws_security_group.vpc_endpoints.id
}