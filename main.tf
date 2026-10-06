module "vpc" {
  source = "./aws-modules/vpc"
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  azs_count            = var.azs_count
  enable_nat_gateway   = var.enable_nat_gateway
  single_nat_gateway   = var.single_nat_gateway
  enable_vpc_endpoints = var.enable_vpc_endpoints
}