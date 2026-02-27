module "vault_k8s" {
  source = "../../modules/vault_k8s"

  cluster_id = "k8s-305-1700-1"
}

module "vault_oidc" {
  source = "../../modules/vault_oidc"

  cluster_id = "k8s-305-1700-1"
}

module "oidc_k8s" {
  source = "../../modules/oidc_k8s"

  cluster_id                         = "k8s-305-1700-1"
  grafana_redirect_uri               = "https://monitoring.305-1700.tdude.co/login/generic_oauth"
  argocd_redirect_uri                = "https://gitops.305-1700.tdude.co/auth/callback"
  oauth2_proxy_redirect_uri          = "https://auth.k8s.305-1700.tdude.co/oauth2/callback"
  envoy_gateway_redirect_uri         = "https://dummy.305-1700.tdude.co/oauth2/callback"
  oidc_allowed_users_assignment_name = module.vault_oidc.oidc_allowed_users_assignment_name
}

module "pocketid_oidc_k8s" {
  source = "../../modules/pocketid_oidc_k8s"

  cluster_id                 = "k8s-305-1700-1"
  grafana_redirect_uri       = "https://monitoring.305-1700.tdude.co/login/generic_oauth"
  argocd_redirect_uri        = "https://gitops.305-1700.tdude.co/auth/callback"
  oauth2_proxy_redirect_uri  = "https://auth.k8s.305-1700.tdude.co/oauth2/callback"
  envoy_gateway_redirect_uri = "https://dummy.305-1700.tdude.co/oauth2/callback"
}

module "pocketid_oidc_family" {
  source = "../../modules/pocketid_oidc_family"

  home_assistant_redirect_uri = "https://ha.305-1700.tdude.co/auth/oidc/callback"
}