# TODO version as input
#https://github.com/alex1989hu/kubelet-serving-cert-approver 0.10.1 version

# Download the file as dynamic-data
resource "terraform_data" "cert_approver_fetch" {
  input = "https://raw.githubusercontent.com/alex1989hu/kubelet-serving-cert-approver/refs/tags/v0.10.2/deploy/standalone-install.yaml"

  provisioner "local-exec" {
    command = "mkdir -p ${path.module}/.terraform-cache && curl -sSL ${self.input} -o ${path.module}/.terraform-cache/cert-approver.yaml"
  }
  provisioner "local-exec" {
    when    = destroy
    command = "rm -f ${path.module}/.terraform-cache/cert-approver.yaml"
  }
}

# Split the YAMLs
locals {
  cert_approver_manifests = fileexists("${path.module}/.terraform-cache/cert-approver.yaml") ? split("---", file("${path.module}/.terraform-cache/cert-approver.yaml")) : []
}

# And apply them
resource "kubectl_manifest" "cert_approver" {
  for_each = { for manifest in local.cert_approver_manifests :
    "${try(yamldecode(manifest).kind, "")}-${try(yamldecode(manifest).metadata.name, "")}" => manifest
    if try(yamldecode(manifest).kind, "") != ""
  }

  yaml_body         = each.value
  server_side_apply = true

  depends_on = [terraform_data.cert_approver_fetch]
}
