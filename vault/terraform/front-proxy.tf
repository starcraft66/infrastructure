resource "vault_mount" "pki_front-proxy" {
  path                      = "${var.cluster_id}/pki/front-proxy"
  type                      = "pki"
  default_lease_ttl_seconds = 3600
  max_lease_ttl_seconds     = 315360000 # 32 Days
}

resource "vault_pki_secret_backend_role" "role_front-proxy_client" {
  backend          = vault_mount.pki_front-proxy.path
  name             = "client"
  ttl              = 3600
  allow_ip_sans    = true
  key_type         = "rsa"
  key_bits         = 4096
  key_usage        = [ "DigitalSignature", "KeyEncipherment", "ClientAuth" ]
  allow_any_name   = true
  allow_subdomains = true
}

resource "vault_policy" "front-proxy_issue" {
  name = "front-proxy-issue"
  policy = <<EOT
path "${vault_mount.pki_front-proxy.path}/issue/*" {
  capabilities = [ "read", "create", "update" ]
}
EOT
}