variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = ""
}
variable "azs_count" {
  description = "Number of availability zones to use"
  type        = number
  default     = 2
  validation {
    condition     = var.azs_count >= 1
    error_message = "azs_count must be at least 1."
  }
}
variable "environment" {
  description = "Name prefix for VPC resources"
  type        = string
  default     = "dev"
}
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}
variable "enable_nat_gateway" {
  description = "Whether to create NAT gateway"
  type        = bool
  default     = true
}
variable "single_nat_gateway" {
  description = "Use one NAT gateway instead of one per AZ"
  type        = bool
  default     = true
}
variable "enable_vpc_endpoints" {
  description = "Whether to create VPC endpoints"
  type        = bool
  default     = true
}
variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}
variable "kubernetes_version" {
  description = "EKS Kubernetes version"
  type        = string
}
variable "cluster_public_access_cidrs" {
  description = "CIDR blocks allowed to access the public EKS API endpoint"
  type        = list(string)
  default     = ["0.0.0.0/0"] #use company/restricted cidr for production
}
variable "admin_principal_arns" {
  description = "IAM principals that should have EKS cluster administrator access"
  type        = set(string)
}
variable "ecr_repositories" {
  description = "ECR repositories to create."
  type = map(object({
    image_tag_mutability = optional(string, "IMMUTABLE")
    scan_on_push         = optional(bool, true)
    force_delete         = optional(bool, false)
  }))
  default = {}
}