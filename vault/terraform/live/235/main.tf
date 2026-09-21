module "vault_k8s" {
  source = "../../modules/vault_k8s"

  cluster_id          = "k8s-235-1"
  generate_root_certs = false
}

module "pocketid_oidc_k8s" {
  source = "../../modules/pocketid_oidc_k8s"

  cluster_id                 = "k8s-235-1"
  grafana_redirect_uri       = "https://monitoring.235.tdude.co/login/generic_oauth"
  argocd_redirect_uri        = "https://gitops.235.tdude.co/auth/callback"
  oauth2_proxy_redirect_uri  = "https://auth.k8s.235.tdude.co/oauth2/callback"
  envoy_gateway_redirect_uri = "https://dummy.235.tdude.co/oauth2/callback"
}
