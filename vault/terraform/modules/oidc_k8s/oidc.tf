resource "vault_identity_oidc_client" "grafana-k8s" {
  name        = "grafana-${var.cluster_id}"
  client_type = "confidential"
  redirect_uris = [
    var.grafana_redirect_uri,
  ]
  assignments = [
    var.oidc_allowed_users_assignment_name,
  ]
  id_token_ttl     = 2400
  access_token_ttl = 7200
}

resource "vault_identity_oidc_client" "argocd-k8s" {
  name        = "argocd-${var.cluster_id}"
  client_type = "confidential"
  redirect_uris = [
    var.argocd_redirect_uri,
  ]
  assignments = [
    var.oidc_allowed_users_assignment_name,
  ]
  id_token_ttl     = 2400
  access_token_ttl = 7200
}

resource "vault_identity_oidc_client" "oauth2-proxy-k8s" {
  name        = "oauth2-proxy-${var.cluster_id}"
  client_type = "confidential"
  redirect_uris = [
    var.oauth2_proxy_redirect_uri,
  ]
  assignments = [
    var.oidc_allowed_users_assignment_name,
  ]
  id_token_ttl     = 2400
  access_token_ttl = 7200
}

resource "vault_identity_oidc_client" "envoy-gateway-k8s" {
  name        = "envoy-gateway-${var.cluster_id}"
  client_type = "confidential"
  redirect_uris = [
    var.envoy_gateway_redirect_uri,
  ]
  assignments = [
    var.oidc_allowed_users_assignment_name,
  ]
  id_token_ttl     = 2400
  access_token_ttl = 7200
}

resource "vault_identity_oidc_client" "kubernetes" {
  name        = "kubernetes-${var.cluster_id}"
  client_type = "public"
  redirect_uris = [
    "http://localhost:8000",
    "http://localhost:18000"
  ]
  assignments = [
    var.oidc_allowed_users_assignment_name,
  ]
  id_token_ttl     = 2400
  access_token_ttl = 7200
}
