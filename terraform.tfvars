aws_region                             = "eu-north-1"
cluster_name                           = "cloudkitchen" #use app name or project name to make it unique.
environment                            = "dev"
kubernetes_version                     = "1.35"
azs_count                              = 2
vpc_cidr                               = "10.0.0.0/16"
enable_nat_gateway                     = true
single_nat_gateway                     = true
enable_vpc_endpoints                   = true
admin_principal_arns                   = ["arn:aws:iam::092620891680:user/admin"] #put the user arn of the user you want to have admin access to the cluster
ecr_repositories                       = ["test"]
cluster_public_access_cidrs            = ["0.0.0.0/0"] #use this to restrict access to the EKS API endpoint. For example, you can use your office IP address or VPN IP address. 
lb_controller_chart_version            = "3.6.0"
argocd_chart_version                   = "10.10.3"
secrets_store_csi_driver_chart_version = ""
secrets                                = { "production/cloudkitchen/application" = {} }
application_secret_names               = ["production/cloudkitchen/application"]

