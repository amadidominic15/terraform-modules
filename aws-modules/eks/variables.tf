variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}
variable "kubernetes_version" {
  description = "EKS Kubernetes version"
  type        = string
}
variable "cluster_role_arn" {
  description = "IAM role ARN used by the EKS control plane"
  type        = string
}
variable "node_role_arn" {
  description = "IAM role ARN used by EKS worker nodes"
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

variable "cluster_security_group_id" {
  description = "Security group ID for the EKS control plane"
  type        = string
}

variable "node_security_group_id" {
  description = "Security group ID for EKS worker nodes"
  type        = string
}

variable "cluster_public_access_cidrs" {
  description = "CIDR blocks allowed to access the public EKS API endpoint"
  type        = list(string)

  validation {
    condition     = length(var.cluster_public_access_cidrs) >= 1
    error_message = "At least one CIDR must be provided."
  }
}
variable "admin_principal_arns" {
  description = "IAM principals that should have EKS cluster administrator access"
  type        = set(string)
}
variable "addons" {
  description = "EKS addons to install. The map key is the EKS addon name."
  type = map(object({
    most_recent = optional(bool, true)
  }))
  default = {}
}
variable "enable_pod_identity" {
  description = "Enable EKS Pod Identity associations."
  type        = bool
  default     = true
}
variable "pod_identity_role_arns" {
  description = "IAM role ARNs used by EKS Pod Identity."

  type    = map(string)
  default = {}
}
variable "node_instance_types" {
  description = "EC2 instance types for the managed node group"
  type        = list(string)
  default     = ["t3.medium"]
}
variable "node_min_size" {
  description = "Minimum number of EC2 worker nodes that the EKS managed node group can scale down to."
  type        = number

  validation {
    condition     = var.node_min_size >= 0
    error_message = "node_min_size must be greater than or equal to 0."
  }
}
variable "node_desired_size" {
  description = "Desired number of EC2 worker nodes in the EKS managed node group."
  type        = number

  validation {
    condition     = var.node_desired_size >= 0
    error_message = "node_desired_size must be greater than or equal to 0."
  }
}
variable "node_max_size" {
  description = "Maximum number of EC2 worker nodes that the EKS managed node group can scale up to."
  type        = number

  validation {
    condition     = var.node_max_size >= 0
    error_message = "node_max_size must be greater than or equal to 0."
  }
}

