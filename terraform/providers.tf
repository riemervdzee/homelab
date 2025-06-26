provider "talos" {}

# provider "kubernetes" {
#   config_path = module.talos_cluster.kubeconfig
# }

provider "helm" {
  kubernetes {
    # TODO we might need to add a sleep before trying? as the talos cluster isn't healthy right away
    # config_path = "~/.kube/config"
    host = module.talos_cluster.kubeconfig.host

    client_certificate     = base64decode(module.talos_cluster.kubeconfig.client_certificate)
    client_key             = base64decode(module.talos_cluster.kubeconfig.client_key)
    cluster_ca_certificate = base64decode(module.talos_cluster.kubeconfig.ca_certificate)
  }
}

# provider "argocd" {
#   server_addr = "localhost:8080"
#   username    = "admin"
#   # password    = var.argocd_admin_password
#   insecure = true
# }
