module "talos_cluster" {
  source = "./talos"

  cluster_name     = "riemers-homelab"
  cluster_endpoint = "https://192.168.10.11:6443"

  controlplane = {
    "192.168.10.11" = {
      hostname = "lab-master-1"
    },
    "192.168.10.12" = {
      hostname = "lab-master-2"
    },
    "192.168.10.13" = {
      hostname = "lab-master-3"
    },
  }
  workers = {
    "192.168.10.14" = {
      hostname = "lab-node-1"
    },
    "192.168.10.20" = {
      hostname = "lab-node-2"
    },
    "192.168.10.21" = {
      hostname = "lab-node-3"
    },
    "192.168.10.22" = {
      hostname = "lab-node-4"
    },
    "192.168.10.23" = {
      hostname = "lab-node-5"
    },
  }
}

module kubelet_cert_approver {
  source = "./kubelet_cert_approver"

  depends_on = [module.talos_cluster]
}

module kubernetes_sigs {
  source = "./kubernetes_sigs"

  depends_on = [module.talos_cluster]
}

module cilium_cni {
  source = "./cilium_cni"

  depends_on = [module.kubernetes_sigs]
}

module "argocd" {
  source              = "./argocd"
  scaleway_access_key = var.scaleway_access_key
  scaleway_secret_key = var.scaleway_secret_key

  depends_on = [module.cilium_cni]
}
