variable "azs_count" {
  description = "number of available zones"
  type        = number
  default     = 2
  validation {
    condition     = var.azs_count >= 1
    error_message = "azs_count must be atleast 1"
  }
}
variable "name_prefix" {
  description = "Common prefix for resource names"
  type        = string
}
variable "environment" {
  description = "deployment environment"
  type        = string
}
variable "project" {
  description = "Project Name"
  type        = string
}
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}
variable "enable_nat_gateway" {
  description = "whether to create NAT gateway"
  type        = bool
  default     = true
}
variable "single_nat_gateway" {
  description = "use one NAT gateway instead of one per AZ"
  type        = bool
  default     = true
}
variable "enable_vpc_endpoints" {
  description = "whether to create VPC endpoints"
  type        = bool
  default     = true
}
variable "vpc_endpoint_security_group_id" {
  description = "Security group ID attached to VPC interface endpoints."
  type        = string
  default     = null
}
variable "tags" {
  description = "Tags applied to vpc resources."
  type        = map(string)
  default     = {}
}
