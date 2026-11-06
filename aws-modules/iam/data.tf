data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "eks_cluster_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "pod_identity_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }
    actions = ["sts:AssumeRole", "sts:TagSession"]
  }
}

data "aws_iam_policy_document" "loki" {
  count = var.enable_loki ? 1 : 0
  statement {
    effect    = "Allow"
    actions   = ["s3:ListBucket", "s3:GetBucketLocation"]
    resources = var.loki_bucket_arn
  }
  statement {
    effect    = "Allow"
    actions   = ["s3:PutObject", "s3:GetObject", "s3:DeleteObject"]
    resources = [for arn in var.loki_bucket_arn : "${arn}/*"]
  }
}

# Tempo S3 policy
data "aws_iam_policy_document" "tempo" {
  count = var.enable_tempo ? 1 : 0
  statement {
    effect    = "Allow"
    actions   = ["s3:ListBucket", "s3:GetBucketLocation"]
    resources = [var.tempo_bucket_arn]
  }
  statement {
    effect    = "Allow"
    actions   = ["s3:PutObject", "s3:GetObject", "s3:DeleteObject"]
    resources = ["${var.tempo_bucket_arn}/*"]
  }
}

data "aws_iam_policy_document" "application_secrets" {
  for_each = var.enable_application_secrets ? var.application_secrets : {}
  statement {
    sid       = "ReadApplicationSecret"
    effect    = "Allow"
    actions   = ["secretsmanager:GetSecretValue", "secretsmanager:DescribeSecret"]
    resources = each.value.secret_arns
  }

  dynamic "statement" {
    for_each = length(each.value.kms_key_arns) > 0 ? [1] : []
    content {
      sid       = "DecryptApplicationSecrets"
      effect    = "Allow"
      actions   = ["kms:Decrypt"]
      resources = each.value.kms_key_arns
    }
  }
}

data "aws_iam_policy_document" "ecs_task_execution_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}



