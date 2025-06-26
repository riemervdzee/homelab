output "talosconfig" {
  value     = module.talos_cluster.talosconfig
  sensitive = true
}

output "kubeconfig_raw" {
  value     = module.talos_cluster.kubeconfig_raw
  sensitive = true
}
