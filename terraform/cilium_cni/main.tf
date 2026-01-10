resource "helm_release" "cilium" {
  name       = "cilium"
  repository = "https://helm.cilium.io/"
  chart      = "cilium"
  version    = "1.18.4"
  namespace  = "kube-system"

  # Wait for Cilium to be ready before marking complete
  wait          = true
  wait_for_jobs = true
  timeout       = 600

  values = [
    file("${path.module}/cilium-values.yaml")
  ]
}
