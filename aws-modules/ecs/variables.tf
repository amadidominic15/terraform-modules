variable "cluster_name" {
  description = "Name of the ECS cluster."
  type        = string
}
variable "environment" {
  description = "Deployment environment."
  type        = string
}
variable "aws_region" {
  description = "Deployment region."
  type        = string
}
variable "private_subnet_ids" {
  description = "Private subnet IDs for ECS tasks."
  type        = list(string)
  validation {
    condition     = length(var.private_subnet_ids) >= 2
    error_message = "Provide private subnets in at least two Availability Zones."
  }
}
variable "security_group_ids" {
  description = "Security groups attached to ECS tasks."
  type        = list(string)
}
variable "services" {
  description = "Fargate services to deploy."
  type = map(object({
    image             = string
    container_port    = number
    cpu               = optional(number, 256)
    memory            = optional(number, 512)
    desired_count     = optional(number, 2)
    task_role_arn     = optional(string)
    health_check_path = optional(string, "/health")
    environment       = optional(map(string), {})
    secrets           = optional(map(string), {})
  }))
}
variable "log_retention_days" {
  description = "CloudWatch log retention period."
  type        = number
  default     = 30
}
variable "enable_container_insights" {
  description = "Enable ECS Container Insights."
  type        = bool
  default     = true
}
variable "task_execution_role_arn" {
  description = "ARN of the ECS task execution role created by the IAM module"
  type        = string
}
variable "tags" {
  description = "Tags applied to ECS resources"
  type        = map(string)
  default     = {}
}