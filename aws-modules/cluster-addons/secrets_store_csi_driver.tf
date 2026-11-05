resource "helm_release" "secrets_store_csi_driver" {
  name             = "secrets-store-csi-driver-provider-aws"
  repository       = "https://aws.github.io/secrets-store-csi-driver-provider-aws"
  chart            = "secrets-store-csi-driver-provider-aws"
  version          = var.secrets_store_csi_driver_chart_version
  namespace        = "kube-system"
  create_namespace = false
  wait    = true
  timeout = 600
  values = [
    yamlencode({
      awsRegion = var.aws_region
      # Install the CSI driver dependency.
      secrets-store-csi-driver = {
        install = true
        # Enable Kubernetes Secret synchronization.
        syncSecret = {
          enabled = true
        }
        enableSecretRotation = true # Enable automatic secret rotation.
        rotationPollInterval = "1h" # Check for updated secrets at a reasonable interval.
      }
      # Keep the provider chart setting.
      syncSecret = {
        enabled = true
      }
      # EKS Pod Identity token audiences.
      tokenRequests = [
        { audience = "sts.amazonaws.com" },
        { audience = "pods.eks.amazonaws.com" }
      ]
    })
  ]
}