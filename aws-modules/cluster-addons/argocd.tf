resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = var.argocd_chart_version
  namespace        = "argocd"
  create_namespace = true
  wait             = true
  wait_for_jobs    = true
  timeout          = 600
  values = [
    yamlencode({
      configs = {
        params = {
          "server.insecure" = true # Argo CD receives HTTP from Envoy.
        }
      }
      server = {
        service = {
          type = "ClusterIP" # Keep Argo CD internal. Envoy Gateway handles external traffic.
        }
      }
    })
  ]
  depends_on = [helm_release.aws_load_balancer_controller]
}
