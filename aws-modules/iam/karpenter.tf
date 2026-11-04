resource "aws_iam_role" "karpenter_node" {
  count = var.enable_karpenter ? 1 : 0
  name               = "${var.name_prefix}-karpenter-node-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
  tags = {
    Name = "${var.name_prefix}-karpenter-node-role"
  }
}

resource "aws_iam_role_policy_attachment" "karpenter_node_policies" {
  for_each = var.enable_karpenter ? toset([
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]) : toset([])
  role       = aws_iam_role.karpenter_node[0].name
  policy_arn = each.value
}

resource "aws_iam_role" "karpenter_controller" {
  count      = var.enable_karpenter ? 1 : 0
  name               = "${var.name_prefix}-karpenter-controller-role"
  assume_role_policy = data.aws_iam_policy_document.pod_identity_assume_role.json
  tags = {
    Name = "${var.name_prefix}-karpenter-controller-role"
  }
}