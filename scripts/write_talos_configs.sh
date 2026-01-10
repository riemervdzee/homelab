#!/bin/bash
set -e
DIR=$(pwd)

cd terraform

# Writes the output of terraform to kube-config and talos-config
terraform output -json kubeconfig_raw | jq -r . > ~/.kube/config
terraform output -json talosconfig | jq -r . > ~/.talos/config

cd "$DIR"
