output "bucket_ids" {
  description = "Map of logical bucket keys to bucket IDs."
  value       = { for key, bucket in aws_s3_bucket.s3_bucket : key => bucket.id }
}
output "bucket_arns" {
  description = "Map of logical bucket keys to bucket ARNs."
  value       = { for key, bucket in aws_s3_bucket.s3_bucket : key => bucket.arn }
}
output "bucket_names" {
  description = "Map of logical bucket keys to bucket names."
  value       = { for key, bucket in aws_s3_bucket.s3_bucket : key => bucket.bucket }
}
output "bucket_domain_names" {
  description = "Map of logical bucket keys to bucket regional domain names."
  value       = { for key, bucket in aws_s3_bucket.s3_bucket : key => bucket.bucket_regional_domain_name }
}
