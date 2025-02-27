variable "cluster_id" {
  description = "The ID of the cluster"
  type        = string
}

variable "generate_root_certs" {
  description = "Whether to generate root certificates for the Vault PKI backends via terraform"
  type        = bool
  default     = true
}
