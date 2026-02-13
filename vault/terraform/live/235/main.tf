module "vault_k8s" {
  source = "../../modules/vault_k8s"

  cluster_id          = "k8s-235-1"
  generate_root_certs = false
}

module "vault_oidc" {
  source = "../../modules/vault_oidc"

  cluster_id = "k8s-235-1"
}

module "oidc_k8s" {
  source = "../../modules/oidc_k8s"

  cluster_id                         = "k8s-235-1"
  grafana_redirect_uri               = "https://monitoring.235.tdude.co/login/generic_oauth"
  argocd_redirect_uri                = "https://gitops.tdude.co/auth/callback"
  oauth2_proxy_redirect_uri          = "https://auth.k8s.235.tdude.co/oauth2/callback"
  envoy_gateway_redirect_uri         = "https://dummy.235.tdude.co/oauth2/callback"
  oidc_allowed_users_assignment_name = module.vault_oidc.oidc_allowed_users_assignment_name
}
