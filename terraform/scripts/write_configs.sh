#!/bin/bash
set -e

# Writes the output of terraform to kube-config and talos-config
terraform output -json kubeconfig_raw | jq -r . > ~/.kube/config
terraform output -json talosconfig | jq -r . > ~/.talos/config
