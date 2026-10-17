data "aws_iam_policy_document" "eks_cluster_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
    actions = [
      "sts:AssumeRole"
    ]
  }
}

data "aws_iam_policy_document" "eks_node_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = [
      "sts:AssumeRole"
    ]
  }
}

data "aws_iam_policy_document" "pod_identity_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }
    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]
  }
}

data "aws_iam_policy_document" "loki" {
  count = var.enable_loki ? 1 : 0
  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation"
    ]
    resources = [
      var.loki_bucket_arn
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject"
    ]
    resources = [
      "${var.loki_bucket_arn}/*"
    ]
  }
}

data "aws_iam_policy_document" "application_secrets" {
  statement {
    sid    = "ReadApprovedSecrets"
    effect = "Allow"

    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret"
    ]

    resources = var.application_secret_arns
  }

  dynamic "statement" {
    for_each = length(var.application_secrets_kms_key_arns) > 0 ? [1] : []

    content {
      sid       = "DecryptApprovedSecrets"
      effect    = "Allow"
      actions   = ["kms:Decrypt"]
      resources = var.application_secrets_kms_key_arns
    }
  }
}