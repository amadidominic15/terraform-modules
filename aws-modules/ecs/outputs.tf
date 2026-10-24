output "cluster_id" {
  description = "ECS cluster ID."
  value       = aws_ecs_cluster.ecs_cluster.id
}
output "cluster_arn" {
  description = "ECS cluster ARN."
  value       = aws_ecs_cluster.ecs_cluster.arn
}
output "service_names" {
  description = "Names of the ECS services."
  value       = { for name, service in aws_ecs_service.service : name => service.name }
}
output "service_arns" {
  description = "ARNs of the ECS services."
  value       = { for name, service in aws_ecs_service.service : name => service.id }
}
output "ecs_task_execution_role_arn" {
  description = "ARN of the ECS task execution role."
  value       = var.task_execution_role_arn
}
