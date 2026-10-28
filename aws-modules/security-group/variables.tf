variable "name_prefix" {
  description = "Common prefix for resource names"
  type        = string
}
variable "vpc_id" {
  description = "ID of the VPC where the EKS cluster and nodes will be deployed"
  type        = string
}
variable "alb_ingress_cidrs" {
  description = "CIDRs allowed to reach the public ALB."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
variable "application_ports" {
  description = "Container ports allowed from the ALB to ECS."
  type        = set(number)
}
variable "tags" {
  description = "Tags applied to security group resources."
  type        = map(string)
  default     = {}
}