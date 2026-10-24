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
variable "public_subnet_ids" {
  description = "Public subnet IDs for the internet-facing ALB."
  type        = list(string)

  validation {
    condition     = length(var.public_subnet_ids) >= 2
    error_message = "Provide public subnets in at least two Availability Zones."
  }
}
variable "security_group_ids" {
  description = "Security groups attached to ECS tasks."
  type        = list(string)
}
variable "alb_security_group_id" {
  description = "Security group attached to the ALB."
  type        = string
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
    path_pattern      = string
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
variable "vpc_id" {
  description = "VPC ID used by the ALB target groups."
  type        = string
}
variable "tags" {
  description = "Tags applied to ECS resources"
  type        = map(string)
  default     = {}
}
variable "acm_certificate_arn" {
  type = string
}
variable "enable_alb_deletion_protection" {
  description = "Whether to protect the ALB from accidental deletion."
  type        = bool
  default     = true
}