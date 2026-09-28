resource "pocketid_group" "sysadmin" {
  name          = "sysadmin"
  friendly_name = "Sysadmin"
}

# The pinned Pocket ID provider cannot manage API resources or M2M grants.
resource "pocketid_client" "blackbox_monitoring" {
  name      = "Blackbox Monitoring"
  client_id = var.blackbox_monitoring_client_id
  is_public = false

  callback_urls = []

  # Restrict interactive use; the API permission is granted in Pocket ID.
  allowed_user_groups = [
    pocketid_group.sysadmin.id,
  ]
}

resource "pocketid_client" "grafana-k8s" {
  name      = "Grafana"
  is_public = false

  callback_urls = [
    var.grafana_redirect_uri,
  ]

  allowed_user_groups = [
    pocketid_group.sysadmin.id,
  ]
}

resource "pocketid_client" "argocd-k8s" {
  name      = "Argo CD"
  is_public = false

  callback_urls = [
    var.argocd_redirect_uri,
  ]

  allowed_user_groups = [
    pocketid_group.sysadmin.id,
  ]
}

resource "pocketid_client" "argocd-cli" {
  name      = "Argo CD CLI"
  is_public = true

  callback_urls = [
    # ArgoCD CLI
    "http://localhost:8085/auth/callback",
    # ArgoCD Mobile App
    "argocd://auth/callback",
  ]

  logout_callback_urls = [
    "http://localhost:8085"
  ]

  allowed_user_groups = [
    pocketid_group.sysadmin.id,
  ]
}


resource "pocketid_client" "oauth2-proxy-k8s" {
  name      = "OAuth2 Proxy"
  is_public = false

  callback_urls = [
    var.oauth2_proxy_redirect_uri,
  ]

  allowed_user_groups = [
    pocketid_group.sysadmin.id,
  ]
}

resource "pocketid_client" "envoy-gateway-k8s" {
  name      = "Envoy Gateway"
  is_public = false

  callback_urls = [
    var.envoy_gateway_redirect_uri,
  ]

  allowed_user_groups = [
    pocketid_group.sysadmin.id,
  ]
}

resource "pocketid_client" "kubernetes" {
  name      = "Kubernetes"
  is_public = true

  callback_urls = [
    "http://localhost:8000",
    "http://localhost:18000",
  ]

  allowed_user_groups = [
    pocketid_group.sysadmin.id,
  ]
}
