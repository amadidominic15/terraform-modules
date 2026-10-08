terraform {
  backend "s3" {
    bucket  = "terraform-modules-2026"
    key     = "dev/terraform.tfstate"
    region  = var.aws_region
    encrypt = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}

