resource "vault_mount" "pki_front-proxy" {
  path                      = "${var.cluster_id}/pki/front-proxy"
  type                      = "pki"
  default_lease_ttl_seconds = 3600
  max_lease_ttl_seconds     = 315360000 # 32 Days
}

resource "vault_pki_secret_backend_root_cert" "front-proxy" {
  depends_on            = [vault_mount.pki_front-proxy]
  backend               = vault_mount.pki_front-proxy.path
  type                  = "internal"
  common_name           = "${var.cluster_id}/pki/front-proxy"
  ttl                   = "315360000"
  format                = "pem"
  private_key_format    = "der"
  key_type              = "rsa"
  key_bits              = 4096
  exclude_cn_from_sans  = true
}

resource "vault_pki_secret_backend_issuer" "front-proxy" {
  backend     = vault_pki_secret_backend_root_cert.front-proxy.backend
  issuer_ref  = vault_pki_secret_backend_root_cert.front-proxy.issuer_id
}

resource "vault_pki_secret_backend_config_issuers" "front-proxy" {
  backend                       = vault_mount.pki_front-proxy.path
  default                       = vault_pki_secret_backend_issuer.front-proxy.issuer_id
  default_follows_latest_issuer = true
}

resource "vault_pki_secret_backend_role" "role_front-proxy_client" {
  backend          = vault_mount.pki_front-proxy.path
  name             = "client"
  ttl              = 3600
  allow_ip_sans    = true
  key_type         = "rsa"
  key_bits         = 4096
  key_usage        = ["DigitalSignature", "KeyEncipherment", "ClientAuth"]
  allow_any_name   = true
  allow_subdomains = true
}

resource "vault_policy" "front-proxy_issue" {
  name   = "front-proxy-issue"
  policy = <<EOT
path "${vault_mount.pki_front-proxy.path}/issue/*" {
  capabilities = [ "read", "create", "update" ]
}
EOT
}

# Generate moved blocks for all of these resources to move them under module.vault_k8s
