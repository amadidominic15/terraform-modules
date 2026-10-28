locals {
  name_prefix = "${var.environment}-${var.project}-${var.aws_region}"
  services = {
    catalog = {
      image             = "${module.ecr.repository_urls["catalog"]}:latest"
      container_port    = 3000
      cpu               = 256
      memory            = 512
      desired_count     = 2
      health_check_path = "/health"
      path_pattern      = ["/catalog", "/catalog/*"]
      environment       = {}
      secrets           = {}
    }
    orders = {
      image             = "${module.ecr.repository_urls["orders"]}:latest"
      container_port    = 3001
      cpu               = 256
      memory            = 512
      desired_count     = 2
      health_check_path = "/health"
      path_pattern      = ["/orders", "/orders/*"]
      environment       = {}
      secrets           = {}
    }
  }

  alb_services = {
    for name, service in local.services : name => {
      container_port    = service.container_port
      health_check_path = service.health_check_path
      path_pattern      = service.path_pattern
    }
  }
  application_ports = toset([
    for service in values(local.services) : service.container_port
  ])
}
