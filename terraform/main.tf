module "talos_cluster" {
  source = "./talos"

  cluster_name     = "test-cluster"
  cluster_endpoint = "https://192.168.10.14:6443"

  controlplane = {
    "192.168.10.14" = {
      hostname = "controlplane"
    },
  }
  workers = {
    "192.168.10.11" = {
      hostname = "worker-1"
    },
    "192.168.10.12" = {
      hostname = "worker-2"
    },
    "192.168.10.13" = {
      hostname = "worker-3"
    },
  }
}

module "argocd" {
  source              = "./argocd"
  scaleway_access_key = var.scaleway_access_key
  scaleway_secret_key = var.scaleway_secret_key
}