provider "talos" {}

provider "helm" {
  kubernetes = {
    # TODO we might need to add a sleep before trying? as the talos cluster isn't healthy right away
    host = module.talos_cluster.kubeconfig.host

    client_certificate     = base64decode(module.talos_cluster.kubeconfig.client_certificate)
    client_key             = base64decode(module.talos_cluster.kubeconfig.client_key)
    cluster_ca_certificate = base64decode(module.talos_cluster.kubeconfig.ca_certificate)
  }
}

provider "kubectl" {
  host = module.talos_cluster.kubeconfig.host

  client_certificate     = base64decode(module.talos_cluster.kubeconfig.client_certificate)
  client_key             = base64decode(module.talos_cluster.kubeconfig.client_key)
  cluster_ca_certificate = base64decode(module.talos_cluster.kubeconfig.ca_certificate)
}
