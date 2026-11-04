resource "aws_iam_role" "tempo" {
  count              = var.enable_tempo ? 1 : 0
  name               = "${var.name_prefix}-tempo-role"
  assume_role_policy = data.aws_iam_policy_document.pod_identity_assume_role.json
  tags = {
    Name = "${var.name_prefix}-tempo-role"
  }
}

resource "aws_iam_role_policy" "tempo" {
  count  = var.enable_tempo ? 1 : 0
  name   = "tempo-s3-access"
  role   = aws_iam_role.tempo[0].id
  policy = data.aws_iam_policy_document.tempo[0].json
}