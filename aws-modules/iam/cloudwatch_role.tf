resource "aws_iam_role" "cloudwatch" {
  count = var.enable_cloudwatch ? 1 : 0
  name = "${var.cluster_name}-cloudwatch-role"
  assume_role_policy = data.aws_iam_policy_document.pod_identity_assume_role.json
  tags = {
    Name = "${var.cluster_name}-cloudwatch-role"
  }
}

resource "aws_iam_role_policy_attachment" "cloudwatch_agent" {
  count = var.enable_cloudwatch ? 1 : 0
  role       = aws_iam_role.cloudwatch[0].name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "cloudwatch_xray" {
  count = var.enable_cloudwatch ? 1 : 0
  role       = aws_iam_role.cloudwatch[0].name
  policy_arn = "arn:aws:iam::aws:policy/AWSXrayWriteOnlyAccess"
}