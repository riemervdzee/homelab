terraform {
  required_providers {
    talos = {
      source  = "siderolabs/talos"
      version = "0.8.0"
    }
    # kubernetes = {
    #   source = "hashicorp/kubernetes"
    # }
    helm = {
      source  = "hashicorp/helm"
      version = "2.17.0"
    }
    # argocd = {
    #   source = "argoproj-labs/argocd"
    # }
  }
}
