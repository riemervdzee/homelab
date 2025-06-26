variable "cluster_name" {
  description = "A name to provide for the Talos cluster"
  type        = string
}

variable "cluster_endpoint" {
  description = "The endpoint for the Talos cluster"
  type        = string
}

variable "controlplane" {
  description = "A map of controlplane nodes data"
  type = map(object({
    hostname = string
  }))
}

variable "workers" {
  description = "A map of worker nodes data"
  type = map(object({
    hostname = string
  }))
}
