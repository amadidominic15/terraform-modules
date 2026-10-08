variable "cluster_name" {
  description = "Name of the EKS cluster (used for resource naming)"
  type        = string
}
variable "vpc_id" {
  description = "ID of the VPC where the EKS cluster and nodes will be deployed"
  type = string
}
variable "vpc_cidr" {
  description = "CIDR block of the VPC"
  type = string
}
