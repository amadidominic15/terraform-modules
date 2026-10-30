variable "name_prefix" {
  description = "Common prefix for resource names"
  type        = string
}
variable "vpc_id" {
  description = "ID of the VPC where the EKS cluster and nodes will be deployed"
  type        = string
}
# Resource creation controls
variable "create_alb_security_group" {
  description = "Whether to create the ALB security group."
  type        = bool
  default     = false
}

variable "create_ecs_security_group" {
  description = "Whether to create the ECS security group."
  type        = bool
  default     = false
}

variable "create_eks_security_group" {
  description = "Whether to create EKS cluster and node security groups."
  type        = bool
  default     = false
}

variable "create_vpc_endpoints_security_group" {
  description = "Whether to create the VPC interface endpoints security group."
  type        = bool
  default     = false
}

variable "create_rds_security_group" {
  description = "Whether to create the RDS security group."
  type        = bool
  default     = false
}

# ALB configuration
variable "alb_ingress_cidrs" {
  description = "CIDR blocks allowed to access the ALB."
  type        = list(string)
  default     = []
}

# ECS configuration
variable "application_ports" {
  description = "Container ports allowed from the ALB to ECS."
  type        = set(number)
  default     = []
}

# VPC endpoint configuration
variable "vpc_endpoint_client_security_group_ids" {
  description = "Additional security group IDs allowed to access VPC endpoints."
  type        = set(string)
  default     = []
}

variable "vpc_endpoints_allow_eks_nodes" {
  description = "Allow EKS worker nodes to access VPC endpoints."
  type        = bool
  default     = false
}

# RDS configuration
variable "database_client_security_group_ids" {
  description = "Additional security group IDs allowed to access RDS."
  type        = set(string)
  default     = []
}

variable "rds_allow_eks_nodes" {
  description = "Allow EKS worker nodes to access RDS."
  type        = bool
  default     = false
}

variable "database_ports" {
  description = "Database ports allowed through the RDS security group."
  type        = set(number)
  default     = [5432]
}