variable "name_prefix" {
  description = "Common prefix for resource names"
  type        = string
}
variable "buckets" {
  description = "Map of S3 buckets and their configurations."
  type = map(object({
    bucket_name               = string
    purpose                   = optional(string, "General storage")
    versioning_enabled        = optional(bool, true)
    force_destroy             = optional(bool, false)
    enable_encryption         = optional(bool, true)
    kms_key_arn               = optional(string, null)
    lifecycle_expiration_days = optional(number, null)
    tags                      = optional(map(string), {})
  }))
  default = {}
}
variable "environment" {
  description = "Deployment environment"
  type        = string
}
variable "tags" {
  description = "Common tags applied to all buckets."
  type        = map(string)
  default     = {}
}
