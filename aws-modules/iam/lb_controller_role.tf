#AWS Load Balancer Controller - Pod Identity role
#
# This role is intentionally separated from the Helm deployment.
# The policy should be replaced/pinned with the exact version tested
# by your organisation when moving to production.
# ------------------------------------------------------------


resource "aws_iam_role" "load_balancer_controller" {
  count = var.enable_load_balancer_controller ? 1 : 0
  name = "${var.cluster_name}-load-balancer-controller-role"
  assume_role_policy = data.aws_iam_policy_document.pod_identity_assume_role.json
  tags = {
    Name = "${var.cluster_name}-load-balancer-controller-role"
  }
}

resource "aws_iam_role_policy" "load_balancer_controller" {
  name   = "${var.cluster_name}-aws-load-balancer-controller"
  role   = aws_iam_role.load_balancer_controller[0].id
  policy = data.aws_iam_policy_document.load_balancer_controller.json
}
