resource "aws_iam_role" "vpc_cni" {
  count = var.enable_vpc_cni ? 1 : 0

  name = "${var.cluster_name}-vpc-cni-role"

  assume_role_policy = data.aws_iam_policy_document.pod_identity_assume_role.json

  tags = {
    Name = "${var.cluster_name}-vpc-cni-role"
  }
}

resource "aws_iam_role_policy_attachment" "vpc_cni" {
  count = var.enable_vpc_cni ? 1 : 0

  role       = aws_iam_role.vpc_cni[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}