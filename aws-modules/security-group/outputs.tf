output "alb_security_group_id" {
  description = "ALB security group ID."
  value       = try(aws_security_group.alb_sg[0].id, null)
}

output "ecs_security_group_id" {
  description = "ECS security group ID."
  value       = try(aws_security_group.ecs[0].id, null)
}

output "eks_cluster_security_group_id" {
  description = "EKS cluster security group ID."
  value       = try(aws_security_group.eks_cluster[0].id, null)
}

output "eks_nodes_security_group_id" {
  description = "EKS worker nodes security group ID."
  value       = try(aws_security_group.eks_nodes[0].id, null)
}

output "vpc_endpoints_security_group_id" {
  description = "VPC interface endpoints security group ID."
  value       = try(aws_security_group.vpc_endpoints[0].id, null)
}

output "rds_security_group_id" {
  description = "RDS security group ID."
  value       = try(aws_security_group.rds[0].id, null)
}