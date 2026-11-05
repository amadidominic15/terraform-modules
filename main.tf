module "vpc" {
  source                         = "./aws-modules/vpc"
  name_prefix                    = local.name_prefix
  project                        = var.project
  environment                    = var.environment
  vpc_cidr                       = var.vpc_cidr
  azs_count                      = var.azs_count
  enable_nat_gateway             = var.enable_nat_gateway
  single_nat_gateway             = var.single_nat_gateway
  enable_vpc_endpoints           = var.enable_vpc_endpoints
  vpc_endpoint_security_group_id = module.security_group.vpc_endpoints_security_group_id
}

module "security_group" {
  source                              = "./aws-modules/security-group"
  name_prefix                         = local.name_prefix
  vpc_id                              = module.vpc.vpc_id
  create_eks_security_group           = true
  create_vpc_endpoints_security_group = true
  create_rds_security_group           = true
  create_lb_security_group            = true
  create_ecs_security_group           = true
  application_ports                   = local.application_ports
  vpc_endpoints_allow_eks_nodes       = true
  rds_allow_eks_nodes                 = true
  lb_ingress_cidrs                    = ["0.0.0.0/0"]
  database_ports                      = [5432]
}

module "alb" {
  source                     = "./aws-modules/alb"
  name_prefix                = local.name_prefix
  vpc_id                     = module.vpc.vpc_id
  public_subnet_ids          = module.vpc.public_subnets_ids
  security_group_id          = module.security_group.lb_security_group_id
  acm_certificate_arn        = var.acm_certificate_arn
  services                   = local.alb_services
  enable_deletion_protection = true
}

module "eks" {
  source                      = "./aws-modules/eks"
  name_prefix                 = local.name_prefix
  project                     = var.project
  kubernetes_version          = var.kubernetes_version
  cluster_public_access_cidrs = var.cluster_public_access_cidrs
  private_subnet_ids          = module.vpc.private_subnets_ids
  cluster_role_arn            = module.iam.eks_cluster_role_arn
  node_role_arn               = module.iam.eks_node_role_arn
  karpenter_node_role_arn     = module.iam.karpenter_node_role_arn
  cluster_security_group_id   = module.security_group.eks_cluster_security_group_id
  node_security_group_id      = module.security_group.eks_nodes_security_group_id
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
    metrics-server                  = {}
  }
  node_instance_types = var.node_instance_types
  node_min_size       = var.node_min_size
  node_desired_size   = var.node_desired_size
  node_max_size       = var.node_max_size
}

module "cluster_addons" {
  source                                 = "./aws-modules/cluster-addons"
  name_prefix                            = local.name_prefix
  aws_region                             = var.aws_region
  replicas = var.replicas
  vpc_id                                 = module.vpc.vpc_id
  lb_controller_chart_version            = var.lb_controller_chart_version
  argocd_chart_version                   = var.argocd_chart_version
  secrets_store_csi_driver_chart_version = var.secrets_store_csi_driver_chart_version
  karpenter_chart_version                = var.karpenter_chart_version
  deployment_replicas                    = var.deployment_replicas
  depends_on                             = [module.eks]
}

module "secrets_manager" {
  source  = "./aws-modules/secrets-manager"
  secrets = var.secrets
}

module "iam" {
  source                          = "./aws-modules/iam"
  name_prefix                     = local.name_prefix
  aws_region                      = var.aws_region
  enable_vpc_cni                  = true
  enable_ebs_csi                  = true
  enable_cloudwatch               = true
  enable_load_balancer_controller = true
  enable_external_dns             = true
  enable_loki                     = true
  enable_karpenter                = true
  tempo_bucket_arn                = module.s3.bucket_arns["tempo"]
  loki_bucket_arn = [
    module.s3.bucket_arns["loki_chunks"], module.s3.bucket_arns["loki_ruler"]
  ]
  enable_application_secrets = true
  application_secret_arns = concat(
    [for name in var.application_secret_names : module.secrets_manager.secret_arns[name]]
  )
}

module "s3" {
  source      = "./aws-modules/s3"
  name_prefix = local.name_prefix
  environment = var.environment
  buckets = {
    loki_chunks = {
      bucket_name        = "${local.name_prefix}-loki-chunks-1026"
      purpose            = "Loki chunks storage"
      versioning_enabled = true
      enable_encryption  = true
      tags = {
        Name     = "${local.name_prefix}-loki-chunks"
        Workload = "Loki"
      }
    }
    loki_ruler = {
      bucket_name        = "${local.name_prefix}-loki-ruler-1026"
      purpose            = "Loki ruler storage"
      versioning_enabled = true
      enable_encryption  = true
      tags = {
        Name     = "${local.name_prefix}-loki-chunks"
        Workload = "Loki"
      }
    }
    tempo = {
      bucket_name        = "${local.name_prefix}-tempo-1026"
      purpose            = "Tempo storage"
      versioning_enabled = true
      enable_encryption  = true
      tags = {
        Name     = "${local.name_prefix}-tempo"
        Workload = "Tempo"
      }
    }
  }
}

module "ecr" {
  source           = "./aws-modules/ecr"
  project          = var.project
  repository_names = var.repository_names
  force_delete     = true
}

module "rds" {
  source                  = "./aws-modules/rds"
  name_prefix             = local.name_prefix
  rds_engine              = var.rds_engine
  rds_engine_version      = var.rds_engine_version
  rds_instance_class      = var.rds_instance_class
  db_name                 = "application"
  master_username         = "dbadmin"
  port                    = 5432
  private_subnet_ids      = module.vpc.private_subnets_ids
  vpc_security_group_ids  = [module.security_group.rds_security_group_id]
  allocated_storage       = 20
  max_allocated_storage   = 100
  multi_az                = true
  backup_retention_period = 7
  deletion_protection     = true
  monitoring_interval     = 0 # Enhanced Monitoring is disabled until an IAM role is provided.
}

module "ecs" {
  source                    = "./aws-modules/ecs"
  name_prefix               = local.name_prefix
  aws_region                = var.aws_region
  task_execution_role_arn   = module.iam.ecs_task_execution_role_arn
  target_group_arns         = module.alb.target_group_arns
  private_subnet_ids        = module.vpc.private_subnets_ids
  security_group_ids        = [module.security_group.ecs_security_group_id]
  services                  = local.services
  log_retention_days        = 30
  enable_container_insights = true
}
