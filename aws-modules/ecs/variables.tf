variable "name_prefix" {
  description = "Common prefix for resource names"
  type        = string
}
variable "aws_region" {
  description = "AWS deployment region"
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
  description = "Configuration for ECS Fargate services"
  type = map(object({
    image             = string
    container_port    = number
    cpu               = number
    memory            = number
    desired_count     = number
    health_check_path = string
    path_pattern      = list(string)
    task_role_arn     = optional(string, null)
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
variable "default_task_role_arn" {
  description = "Optional default IAM role for ECS tasks."
  type        = string
  default     = null
}
variable "target_group_arns" {
  description = "Target group ARNs keyed by service name."
  type        = map(string)
}
variable "tags" {
  description = "Tags applied to ECS resources"
  type        = map(string)
  default     = {}
}



