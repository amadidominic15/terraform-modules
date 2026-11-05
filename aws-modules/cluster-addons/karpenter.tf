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
      replicas = var.replicas
      controller = {
        resources = {
          requests = {
            cpu    = "250m"
            memory = "256Mi"
          }
          limits = {
            cpu    = "500"
            memory = "512Mi"
          }
        }
      }
    })
  ]
}