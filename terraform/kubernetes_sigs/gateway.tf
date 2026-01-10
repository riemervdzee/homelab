# TODO version as input

# Download the file as dynamic-data
resource "terraform_data" "gateway_api_crds" {
  input = "https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.4.1/standard-install.yaml"

  provisioner "local-exec" {
    command = "mkdir -p ${path.module}/.terraform-cache && curl -sSL ${self.input} -o ${path.module}/.terraform-cache/gateway_api_crds.yaml"
  }
  provisioner "local-exec" {
    when    = destroy
    command = "rm -f ${path.module}/.terraform-cache/gateway_api_crds.yaml"
  }
}

# Split the YAMLs
locals {
  gateway_api_manifests = fileexists("${path.module}/.terraform-cache/gateway_api_crds.yaml") ? split("---", file("${path.module}/.terraform-cache/gateway_api_crds.yaml")) : []
}

# And apply them
resource "kubectl_manifest" "gateway_api_crds" {
  for_each = { for manifest in local.gateway_api_manifests :
    "${try(yamldecode(manifest).kind, "")}-${try(yamldecode(manifest).metadata.name, "")}" => manifest
    if try(yamldecode(manifest).kind, "") != ""
  }

  yaml_body         = each.value
  server_side_apply = true

  depends_on = [terraform_data.gateway_api_crds]
}
