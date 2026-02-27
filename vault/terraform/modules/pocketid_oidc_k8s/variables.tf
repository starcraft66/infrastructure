variable "cluster_id" {
  type = string
}

variable "grafana_redirect_uri" {
  type = string
}

variable "argocd_redirect_uri" {
  type = string
}

variable "oauth2_proxy_redirect_uri" {
  type = string
}

variable "envoy_gateway_redirect_uri" {
  type = string
}
