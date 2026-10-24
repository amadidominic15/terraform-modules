resource "aws_iam_role" "application_secrets" {
  count              = var.enable_application_secrets ? 1 : 0
  name               = "${var.cluster_name}-application-secrets-role"
  assume_role_policy = data.aws_iam_policy_document.pod_identity_assume_role.json
  tags = {
    Name      = "${var.cluster_name}-application-secrets-role"
    Purpose   = "ApplicationSecretsAccess"
    ManagedBy = "Terraform"
  }
}

resource "aws_iam_role_policy" "application_secrets" {
  count  = var.enable_application_secrets ? 1 : 0
  name   = "${var.cluster_name}-application-secrets-policy"
  role   = aws_iam_role.application_secrets[0].id
  policy = data.aws_iam_policy_document.application_secrets.json
  lifecycle {
    precondition {
      condition     = length(var.application_secret_arns) > 0
      error_message = "At least one secret ARN is required when application secrets access is enabled."
    }
  }
}