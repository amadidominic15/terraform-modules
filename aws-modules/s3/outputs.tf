output "loki_bucket_name" {
  description = "S3 bucket name used for Loki storage."

  value = var.enable_loki ? aws_s3_bucket.loki[0].bucket : null
}
output "loki_bucket_arn" {
  description = "S3 bucket ARN used for Loki storage."
  value = var.enable_loki ? aws_s3_bucket.loki[0].arn : null
}