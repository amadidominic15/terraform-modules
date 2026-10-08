resource "aws_iam_role" "load_balancer_controller" {
  count = var.enable_load_balancer_controller ? 1 : 0
  name = "${var.cluster_name}-load-balancer-controller-role"
  assume_role_policy = data.aws_iam_policy_document.pod_identity_assume_role.json
  tags = {
    Name = "${var.cluster_name}-load-balancer-controller-role"
  }
}

resource "aws_iam_role_policy" "load_balancer_controller" {
  count = var.enable_load_balancer_controller ? 1 : 0
  name = "${var.cluster_name}-aws-load-balancer-controller"
  role = aws_iam_role.load_balancer_controller[0].id
  policy = file("${path.module}/${var.load_balancer_controller_policy_file}")
}
