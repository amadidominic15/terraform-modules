variable "name_prefix" {
  description = "Common prefix for resource names"
  type        = string
}
variable "vpc_id" {
  type = string
}
variable "public_subnet_ids" {
  description = "Public subnet IDs for the internet-facing ALB."
  type        = list(string)
  validation {
    condition     = length(var.public_subnet_ids) >= 2
    error_message = "Provide public subnets in at least two Availability Zones."
  }
}
variable "security_group_id" {
  type = string
}
variable "acm_certificate_arn" {
  type = string
}
variable "services" {
  type = map(object({
    container_port    = number
    health_check_path = string
    path_pattern      = list(string)
  }))
}
variable "enable_deletion_protection" {
  type    = bool
  default = true
}
variable "tags" {
  description = "Tags applied to supported resources."
  type        = map(string)
  default     = {}
}