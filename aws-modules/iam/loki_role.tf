resource "aws_iam_role" "loki" {
  count              = var.enable_loki ? 1 : 0
  name               = "${var.name_prefix}-loki-role"
  assume_role_policy = data.aws_iam_policy_document.pod_identity_assume_role.json
  tags = {
    Name = "${var.name_prefix}-loki-role"
  }
}

resource "aws_iam_role_policy" "loki" {
  count  = var.enable_loki ? 1 : 0
  name   = "${var.name_prefix}-loki-s3"
  role   = aws_iam_role.loki[0].id
  policy = data.aws_iam_policy_document.loki[0].json
}