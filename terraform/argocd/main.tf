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

# Deploy argocd bootstrap application TODO change github url to a template param
resource "kubectl_manifest" "argocd-root-application" {
  yaml_body = file("${path.module}/files/argocd-root-application.yaml")
}

# Deploy ESO namespace and secret so it can connect to Scaleway
resource "kubectl_manifest" "eso-namespace" {
  yaml_body = file("${path.module}/files/eso-namespace.yaml")
}
resource "kubectl_manifest" "eso-scaleway-secret" {
  yaml_body = templatefile("${path.module}/files/eso-scaleway-secret.yaml.tmpl", {
    access_key = base64encode(var.scaleway_access_key)
    secret_key = base64encode(var.scaleway_secret_key)
  })
}
