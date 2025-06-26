# TODO aanmaken wachtwoord in terraform?
# TODO aanmaken redis wachtwoord in terraform?

resource "helm_release" "argocd" {
  name             = "argocd"
  namespace        = "argocd"
  create_namespace = true

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "8.0.2"

  # values = [
  #   file("values/argocd-values.yaml")  # optional custom values
  # ]
}

resource "kubectl_manifest" "argocd-root-application" {
  yaml_body = file("${path.module}/files/argocd-root-application.yaml")
}