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
  value       = { for key, service in aws_ecs_service.service : key => service.name }
}
output "service_arns" {
  description = "ARNs of the ECS services."
  value       = { for key, service in aws_ecs_service.service : key => service.id }
}
output "task_definition_arns" {
  value = {
  for key, task in aws_ecs_task_definition.service : key => task.arn }
}
output "ecs_task_execution_role_arn" {
  description = "ARN of the ECS task execution role."
  value       = var.task_execution_role_arn
}
