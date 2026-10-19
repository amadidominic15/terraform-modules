
resource "helm_release" "secrets_store_csi_driver" {
  name             = "secrets-store-csi-driver-provider-aws"
  repository       = "https://aws.github.io/secrets-store-csi-driver-provider-aws"
  chart            = "secrets-store-csi-driver-provider-aws"
  version          = var.secrets_store_csi_driver_chart_version
  namespace        = "kube-system"
  create_namespace = false
  wait             = true
  timeout          = 600
  values = [
    yamlencode({
      awsRegion = var.aws_region
      # Use the AWS provider chart's built-in CSI driver dependency.
      secrets-store-csi-driver = {
        install = true
      }
      # Request the token audiences needed for Pod Identity.
      tokenRequests = [
        { audience = "sts.amazonaws.com" },
        { audience = "pods.eks.amazonaws.com" }
      ]
    })
  ]
}
