variable "name_prefix" {
  description = "Common prefix for resource names"
  type        = string
}
variable "skip_final_snapshot" {
  description = "Whether to skip the final snapshot when deleting the RDS instance."
  type        = bool
  default     = false
}
variable "rds_engine" {
  description = "Database engine: postgres or mysql."
  type        = string
  default     = "postgres"
  validation {
    condition     = contains(["postgres", "mysql"], var.rds_engine)
    error_message = "Engine must be postgres or mysql."
  }
}
variable "rds_engine_version" {
  description = "Supported database engine version for the target AWS region."
  type        = string
}
variable "rds_instance_class" {
  description = "RDS DB instance class."
  type        = string
  default     = "db.t3.small"
}
variable "db_name" {
  description = "Initial database name."
  type        = string
}
variable "private_subnet_ids" {
  description = "Private subnet IDs used by EKS"
  type        = list(string)
  validation {
    condition     = length(var.private_subnet_ids) >= 1
    error_message = "At least one private subnet is required."
  }
}
variable "vpc_security_group_ids" {
  description = "Security group IDs attached to RDS."
  type        = list(string)
}
variable "master_username" {
  description = "Administrative database username"
  type        = string
}
variable "port" {
  description = "Database listener port."
  type        = number
  default     = 5432
}
variable "allocated_storage" {
  description = "Initial storage size in GiB."
  type        = number
  default     = 20
}
variable "max_allocated_storage" {
  description = "Maximum storage size in GiB for autoscaling."
  type        = number
  default     = 100
}
variable "multi_az" {
  description = "Enable synchronous standby deployment across AZs."
  type        = bool
  default     = true
}
variable "backup_retention_period" {
  description = "Automated backup retention in days."
  type        = number
  default     = 7
  validation {
    condition     = var.backup_retention_period >= 1 && var.backup_retention_period <= 35
    error_message = "Backup retention must be between 1 and 35 days."
  }
}
variable "backup_window" {
  description = "Preferred UTC backup window."
  type        = string
  default     = "01:00-02:00"
}
variable "maintenance_window" {
  description = "Preferred UTC maintenance window."
  type        = string
  default     = "sun:03:00-sun:04:00"
}
variable "deletion_protection" {
  description = "Prevent accidental RDS deletion at the AWS API level."
  type        = bool
  default     = true
}
variable "storage_kms_key_id" {
  description = "Optional customer-managed KMS key ARN for storage encryption."
  type        = string
  default     = null
}
variable "monitoring_interval" {
  description = "Enhanced Monitoring interval in seconds; 0 disables it."
  type        = number
  default     = 60
  validation {
    condition     = contains([0, 1, 5, 10, 15, 30, 60], var.monitoring_interval)
    error_message = "Use 0, 1, 5, 10, 15, 30, or 60 seconds."
  }
}
variable "monitoring_role_arn" {
  description = "IAM role ARN for RDS Enhanced Monitoring when enabled."
  type        = string
  default     = null
}
variable "enabled_cloudwatch_logs_exports" {
  description = "Supported database log types to export to CloudWatch."
  type        = list(string)
  default     = ["postgresql"]
}
variable "tags" {
  description = "Tags applied to RDS resources."
  type        = map(string)
  default     = {}
}
