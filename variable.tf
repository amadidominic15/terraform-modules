variable "aws_region" {}
variable "azs_count" {}
variable "environment" {}
variable "vpc_cidr" {}
variable "enable_nat_gateway" {}
variable "single_nat_gateway" {}
variable "enable_vpc_endpoints" {}
variable "cluster_name" {}
variable "kubernetes_version" {}
variable "cluster_public_access_cidrs" {}
variable "admin_principal_arns" {}
variable "ecr_repositories" {}
variable "lb_controller_chart_version" {}
variable "argocd_chart_version" {}
variable "secrets_store_csi_driver_chart_version" {}
variable "secrets" {}
variable "application_secret_names" {
  description = "Secret names this application's IAM role is allowed to read."
  type        = list(string)
}