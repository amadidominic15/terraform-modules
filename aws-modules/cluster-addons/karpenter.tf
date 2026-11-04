resource "helm_release" "karpenter" {
  name             = "karpenter"
  namespace        = "karpenter"
  repository       = "oci://public.ecr.aws/karpenter"
  chart            = "karpenter"
  version          = var.karpenter_chart_version
  create_namespace = true
  wait             = true
  timeout          = 600
  values = [
    yamlencode({
      serviceAccount = {
        create = true
        name   = "karpenter"
      }
      settings = {
        clusterName = "${var.name_prefix}-eks"
      }
      replicas = 2
      controller = {
        resources = {
          requests = {
            cpu    = "500m"
            memory = "512Mi"
          }
          limits = {
            cpu    = "1"
            memory = "1Gi"
          }
        }
      }
    })
  ]
}