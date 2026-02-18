variable "compartment_id" {
  description = "OCI compartment OCID for all resources"
  type        = string
}

variable "tenancy_id" {
  description = "OCI tenancy OCID"
  type        = string
}

variable "region" {
  description = "OCI region"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version for OKE cluster and node pools"
  type        = string
}

variable "kubernetes_worker_nodes" {
  description = "Number of worker nodes in the node pool"
  type        = number
}

variable "ssh_public_key" {
  description = "SSH public key for node access"
  type        = string
}
