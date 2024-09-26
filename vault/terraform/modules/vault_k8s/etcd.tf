resource "vault_mount" "pki_etcd" {
  path                      = "${var.cluster_id}/pki/etcd"
  type                      = "pki"
  default_lease_ttl_seconds = 3600
  max_lease_ttl_seconds     = 315360000 # 32 Days
}

resource "vault_pki_secret_backend_role" "role_etcd_peer" {
  backend          = vault_mount.pki_etcd.path
  name             = "peer"
  ttl              = 3600
  allow_ip_sans    = true
  key_type         = "rsa"
  key_bits         = 4096
  key_usage        = ["DigitalSignature", "KeyEncipherment", "ServerAuth", "ClientAuth"]
  allow_any_name   = true
  allow_subdomains = true
}

resource "vault_pki_secret_backend_role" "role_etcd_server" {
  backend          = vault_mount.pki_etcd.path
  name             = "server"
  ttl              = 3600
  allow_ip_sans    = true
  key_type         = "rsa"
  key_bits         = 4096
  key_usage        = ["DigitalSignature", "KeyEncipherment", "ServerAuth"]
  allow_any_name   = true
  allow_subdomains = true
}

resource "vault_pki_secret_backend_role" "role_etcd_client" {
  backend          = vault_mount.pki_etcd.path
  name             = "client"
  ttl              = 3600
  allow_ip_sans    = true
  key_type         = "rsa"
  key_bits         = 4096
  key_usage        = ["DigitalSignature", "KeyEncipherment", "ClientAuth"]
  allow_any_name   = true
  allow_subdomains = true
}

resource "vault_policy" "etcd_issue" {
  name   = "etcd-issue"
  policy = <<EOT
path "${vault_mount.pki_etcd.path}/issue/*" {
  capabilities = [ "read", "create", "update" ]
}
EOT
}

resource "vault_approle_auth_backend_role" "etcd" {
  backend        = vault_auth_backend.approle.path
  role_name      = "${var.cluster_id}-node-etcd"
  token_policies = [vault_policy.etcd_issue.name]
}

# Generate moved blocks for all of these resources to move them under module.vault_k8s
