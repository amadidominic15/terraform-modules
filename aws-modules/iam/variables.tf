variable "cluster_name" {
  description = "Name of the EKS cluster."
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