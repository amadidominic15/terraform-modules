variable "name_prefix" {
  description = "Common prefix for resource names"
  type        = string
}
variable "enable_vpc_cni" {
  description = "Create IAM role for VPC CNI."
  type        = bool
  default     = true
}
variable "enable_ebs_csi" {
  description = "Create IAM role for EBS CSI."
  type        = bool
  default     = true
}
variable "enable_cloudwatch" {
  description = "Create IAM role for CloudWatch Observability."
  type        = bool
  default     = false
}
variable "enable_load_balancer_controller" {
  description = "Create IAM role for AWS Load Balancer Controller."
  type        = bool
  default     = true
}
variable "enable_external_dns" {
  description = "Create IAM role for ExternalDNS."
  type        = bool
  default     = false
}
variable "load_balancer_controller_policy_file" {
  description = "Path to the AWS Load Balancer Controller IAM policy file relative to the IAM module."
  type        = string
  default     = "aws_lb_policies/aws-load-balancer-controller.json"
}
variable "loki_bucket_arn" {
  description = "ARN of the S3 bucket used by Loki."
  type        = list(string)
  default     = []
}
variable "enable_loki" {
  description = "Whether to create an S3 bucket for Loki."
  type        = bool
  default     = false
}
variable "enable_application_secrets" {
  description = "Whether to create the application secrets access role."
  type        = bool
  default     = false
}
variable "application_secret_arns" {
  description = "Exact Secrets Manager ARNs this application can read."
  type        = list(string)
  default     = []
}
variable "application_secrets_kms_key_arns" {
  description = "Customer-managed KMS key ARNs required to decrypt secrets."
  type        = list(string)
  default     = []
}
variable "tags" {
  description = "Tags applied to supported resources."
  type        = map(string)
  default     = {}
}