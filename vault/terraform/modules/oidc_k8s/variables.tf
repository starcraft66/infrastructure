variable "argocd_redirect_uri" {
  description = "The redirect URI for the ArgoCD OIDC client"
  type        = string
}

variable "oauth2_proxy_redirect_uri" {
  description = "The redirect URI for the oauth2-proxy OIDC client"
  type        = string
}

variable "grafana_redirect_uri" {
  description = "The redirect URI for the Grafana OIDC client"
  type        = string
}

variable "oidc_allowed_users_assignment_name" {
  description = "The name of the OIDC assignment for allowed users"
  type        = string
}

variable "cluster_id" {
  description = "The ID of the cluster"
  type        = string
}