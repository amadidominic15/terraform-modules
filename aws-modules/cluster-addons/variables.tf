variable "cluster_name" {
  description = "Name of the EKS cluster."
  type        = string
}
variable "aws_region" {
  description = "AWS region containing the EKS cluster."
  type        = string
}
variable "vpc_id" {
  description = "VPC ID used by the Load Balancer Controller."
  type        = string
}
variable "lb_controller_chart_version" {
  description = "Pinned AWS Load Balancer Controller Helm chart version."
  type        = string
}
variable "argocd_chart_version" {
  description = "Pinned Argo CD Helm chart version."
  type        = string
}
variable "secrets_store_csi_driver_chart_version" {
  description = "Pinned AWS Secrets Store CSI Driver provider Helm chart version."
  type        = string
}
variable "acm_certificate_arn" {
  type = string
}
variable "envoy_gateway_version" {
  type    = string
  default = "1.9.2"
}
variable "deployment_replicas" {
  type = number
}
