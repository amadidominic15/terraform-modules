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
  value       = aws_security_group.vpc_endpoints.id
}
output "rds_security_group_id" {
  description = "Security group ID attached to RDS."
  value       = aws_security_group.rds.id
}
output "ecs_security_group_id" {
  description = "ID of the ECS task security group"
  value       = aws_security_group.ecs.id
}
output "ecs_security_group_arn" {
  description = "ARN of the ECS task security group"
  value       = aws_security_group.ecs.arn
}
output "alb_security_group_id" {
  description = "ID of the ALB security group"
  value       = aws_security_group.alb_sg.id
}