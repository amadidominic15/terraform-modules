module "vpc" {
  source               = "./aws-modules/vpc"
  environment          = var.environment
  aws_region           = var.aws_region
  vpc_cidr             = var.vpc_cidr
  azs_count            = var.azs_count
  enable_nat_gateway   = var.enable_nat_gateway
  single_nat_gateway   = var.single_nat_gateway
  enable_vpc_endpoints = var.enable_vpc_endpoints
  vpc_endpoint_security_group_id = module.security_group.vpc_endpoint_security_group_id
}

module "security_group" {
  source       = "./aws-modules/security-group"
  cluster_name = var.cluster_name
  vpc_id       = module.vpc.vpc_id
  vpc_cidr     = var.vpc_cidr
}

module "eks" {
  source                      = "./aws-modules/eks"
  cluster_name                = var.cluster_name
  kubernetes_version          = var.kubernetes_version
  cluster_public_access_cidrs = var.cluster_public_access_cidrs
  private_subnet_ids          = module.vpc.private_subnets_ids
  cluster_role_arn            = module.iam.eks_cluster_role_arn
  node_role_arn               = module.iam.eks_node_role_arn
  cluster_security_group_id   = module.security_group.cluster_security_group_id
  node_security_group_id      = module.security_group.nodes_security_group_id
  admin_principal_arns        = var.admin_principal_arns
  enable_pod_identity         = true
  pod_identity_role_arns      = module.iam.pod_identity_role_arns
  addons = {
    coredns                         = {}
    kube-proxy                      = {}
    vpc-cni                         = {}
    eks-pod-identity-agent          = {}
    aws-ebs-csi-driver              = {}
    amazon-cloudwatch-observability = {}
  }
  node_instance_types = ["t3.medium"]
  node_min_size       = 1
  node_desired_size   = 2
  node_max_size       = 3
}

module "iam" {
  source                          = "./aws-modules/iam"
  cluster_name                    = var.cluster_name
  enable_vpc_cni                  = true
  enable_ebs_csi                  = true
  enable_cloudwatch               = true
  enable_load_balancer_controller = true
  enable_external_dns             = true
  enable_loki                     = true
  loki_bucket_arn                 = module.s3.loki_bucket_arn
}

module "s3" {
  source       = "./aws-modules/s3"
  cluster_name = var.cluster_name
  enable_loki  = true
}

module "ecr" {
  source = "./aws-modules/ecr"
  ecr_repositories = var.ecr_repositories
}