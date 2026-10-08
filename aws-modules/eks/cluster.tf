resource "aws_kms_key" "eks" {
  description             = "KMS key for EKS Kubernetes secrets encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "EnableAccountRoot"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      }
    ]
  })
  tags = {
    Name = "${var.cluster_name}-eks-kms"
  }
}

resource "aws_kms_alias" "eks" {
  name          = "alias/${var.cluster_name}-eks"
  target_key_id = aws_kms_key.eks.key_id
}

resource "aws_cloudwatch_log_group" "eks" {
  name              = "/aws/eks/${var.cluster_name}/cluster"
  retention_in_days = 30
  kms_key_id        = aws_kms_key.eks.arn
}

resource "aws_eks_cluster" "eks" {
  name     = var.cluster_name
  role_arn = var.cluster_role_arn
  version  = var.kubernetes_version
  access_config {
    authentication_mode = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = false
  }
  vpc_config {
    subnet_ids = var.private_subnet_ids
    security_group_ids = [
      var.cluster_security_group_id
    ]
    endpoint_private_access = true
    endpoint_public_access  = true
    public_access_cidrs = var.cluster_public_access_cidrs
  }
  enabled_cluster_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]
  encryption_config {
    provider {
      key_arn = aws_kms_key.eks.arn
    }
    resources = [
      "secrets"
    ]
  }
  depends_on = [ aws_cloudwatch_log_group.eks ]
}