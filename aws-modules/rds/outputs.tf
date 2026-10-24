
output "db_instance_id" {
  description = "RDS DB instance identifier."
  value       = aws_db_instance.db_instance
}

output "db_instance_arn" {
  description = "RDS DB instance ARN."
  value       = aws_db_instance.db_instance
}

output "endpoint" {
  description = "RDS endpoint hostname."
  value       = aws_db_instance.db_instance
}

output "port" {
  description = "RDS database port."
  value       = aws_db_instance.db_instance
}

output "database_name" {
  description = "Initial database name."
  value       = aws_db_instance.db_instance
}

output "master_username" {
  description = "RDS master username."
  value       = aws_db_instance.db_instance
}

output "master_secret_arn" {
  description = "ARN of the RDS-managed master credentials secret."
  value       = try(aws_db_instance.db_instance, null)
}

output "security_group_ids" {
  description = "Security groups attached to the database."
  value       = aws_db_instance.db_instance
}
