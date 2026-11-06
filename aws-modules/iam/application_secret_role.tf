resource "aws_iam_role" "application_secrets" {
  for_each           = var.enable_application_secrets ? var.application_secrets : {}
  name               = "${var.name_prefix}-${each.key}-secrets-role"
  assume_role_policy = data.aws_iam_policy_document.pod_identity_assume_role.json
  tags = {
    Name    = "${var.name_prefix}-${each.key}-secrets-role"
    Purpose = "ApplicationSecretsAccess"
  }
}

resource "aws_iam_role_policy" "application_secrets" {
  for_each = var.enable_application_secrets ? var.application_secrets : {}
  name     = "${var.name_prefix}-${each.key}-secrets-policy"
  role     = aws_iam_role.application_secrets[each.key].id
  policy   = data.aws_iam_policy_document.application_secrets[each.key].json
  lifecycle {
    precondition {
      condition     = length(each.value.secret_arns) > 0
      error_message = "At least one secret ARN is required for each application."
    }
  }
}

