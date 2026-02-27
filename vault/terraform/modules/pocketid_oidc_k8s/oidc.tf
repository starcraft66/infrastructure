resource "pocketid_group" "sysadmin" {
  name          = "sysadmin"
  friendly_name = "Sysadmin"
}

resource "pocketid_client" "grafana-k8s" {
  name      = "grafana-${var.cluster_id}"
  is_public = false

  callback_urls = [
    var.grafana_redirect_uri,
  ]

  allowed_user_groups = [
    pocketid_group.sysadmin.id,
  ]
}

resource "pocketid_client" "argocd-k8s" {
  name      = "argocd-${var.cluster_id}"
  is_public = false

  callback_urls = [
    var.argocd_redirect_uri,
  ]

  allowed_user_groups = [
    pocketid_group.sysadmin.id,
  ]
}

resource "pocketid_client" "oauth2-proxy-k8s" {
  name      = "oauth2-proxy-${var.cluster_id}"
  is_public = false

  callback_urls = [
    var.oauth2_proxy_redirect_uri,
  ]

  allowed_user_groups = [
    pocketid_group.sysadmin.id,
  ]
}

resource "pocketid_client" "envoy-gateway-k8s" {
  name      = "envoy-gateway-${var.cluster_id}"
  is_public = false

  callback_urls = [
    var.envoy_gateway_redirect_uri,
  ]

  allowed_user_groups = [
    pocketid_group.sysadmin.id,
  ]
}

resource "pocketid_client" "kubernetes" {
  name      = "kubernetes-${var.cluster_id}"
  is_public = true

  callback_urls = [
    "http://localhost:8000",
    "http://localhost:18000",
  ]

  allowed_user_groups = [
    pocketid_group.sysadmin.id,
  ]
}
