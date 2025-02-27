resource "vault_mount" "pki_kubernetes" {
  path                      = "${var.cluster_id}/pki/kubernetes"
  type                      = "pki"
  default_lease_ttl_seconds = 3600
  max_lease_ttl_seconds     = 315360000 # 32 Days
}

resource "vault_pki_secret_backend_root_cert" "kubernetes" {
  depends_on           = [vault_mount.pki_kubernetes]
  backend              = vault_mount.pki_kubernetes.path
  type                 = "internal"
  common_name          = "${var.cluster_id}/pki/kubernetes"
  ttl                  = "315360000"
  format               = "pem"
  private_key_format   = "der"
  key_type             = "rsa"
  key_bits             = 4096
  exclude_cn_from_sans = true
  count                = var.generate_root_certs ? 1 : 0
}

resource "vault_pki_secret_backend_issuer" "kubernetes" {
  backend    = vault_pki_secret_backend_root_cert.kubernetes[0].backend
  issuer_ref = vault_pki_secret_backend_root_cert.kubernetes[0].issuer_id
  count      = var.generate_root_certs ? 1 : 0
}

resource "vault_pki_secret_backend_config_issuers" "kubernetes" {
  backend                       = vault_mount.pki_kubernetes.path
  default                       = vault_pki_secret_backend_issuer.kubernetes[0].issuer_id
  default_follows_latest_issuer = true
  count                         = var.generate_root_certs ? 1 : 0
}

resource "vault_pki_secret_backend_role" "role_kubernetes_peer_group_membership" {
  backend           = vault_mount.pki_kubernetes.path
  name              = "peer-${replace(each.value, ":", "_")}"
  ttl               = 3600
  allow_ip_sans     = true
  key_type          = "rsa"
  key_bits          = 4096
  key_usage         = ["DigitalSignature", "KeyEncipherment", "ServerAuth", "ClientAuth"]
  organization      = [each.value]
  allow_any_name    = true
  enforce_hostnames = false
  allow_subdomains  = true
  for_each          = toset(["system:nodes"])
}

resource "vault_pki_secret_backend_role" "role_kubernetes_server_group_membership" {
  backend           = vault_mount.pki_kubernetes.path
  name              = "server-${replace(each.value, ":", "_")}"
  ttl               = 3600
  allow_ip_sans     = true
  key_type          = "rsa"
  key_bits          = 4096
  key_usage         = ["DigitalSignature", "KeyEncipherment", "ServerAuth"]
  organization      = [each.value]
  allow_any_name    = true
  enforce_hostnames = false
  allow_subdomains  = true
  for_each          = toset(["system:masters"])
}

resource "vault_pki_secret_backend_role" "role_kubernetes_client_group_membership" {
  backend           = vault_mount.pki_kubernetes.path
  name              = "client-${replace(each.value, ":", "_")}"
  ttl               = 3600
  allow_ip_sans     = true
  key_type          = "rsa"
  key_bits          = 4096
  key_usage         = ["DigitalSignature", "KeyEncipherment", "ClientAuth"]
  organization      = [each.value]
  allow_any_name    = true
  enforce_hostnames = false
  allow_subdomains  = true
  for_each          = toset(["system:masters", "system:kube-controller-manager", "system:kube-scheduler", "system:node-proxier", "system:nodes"])
}

resource "vault_pki_secret_backend_role" "role_kubernetes_peer" {
  backend           = vault_mount.pki_kubernetes.path
  name              = "peer"
  ttl               = 3600
  allow_ip_sans     = true
  key_type          = "rsa"
  key_bits          = 4096
  key_usage         = ["DigitalSignature", "KeyEncipherment", "ServerAuth", "ClientAuth"]
  allow_any_name    = true
  enforce_hostnames = false
  allow_subdomains  = true
}

resource "vault_pki_secret_backend_role" "role_kubernetes_server" {
  backend           = vault_mount.pki_kubernetes.path
  name              = "server"
  ttl               = 3600
  allow_ip_sans     = true
  key_type          = "rsa"
  key_bits          = 4096
  key_usage         = ["DigitalSignature", "KeyEncipherment", "ServerAuth"]
  allow_any_name    = true
  enforce_hostnames = false
  allow_subdomains  = true
}

resource "vault_pki_secret_backend_role" "role_kubernetes_client" {
  backend           = vault_mount.pki_kubernetes.path
  name              = "client"
  ttl               = 3600
  allow_ip_sans     = true
  key_type          = "rsa"
  key_bits          = 4096
  key_usage         = ["DigitalSignature", "KeyEncipherment", "ClientAuth"]
  allow_any_name    = true
  enforce_hostnames = false
  allow_subdomains  = true
}

resource "vault_policy" "kubernetes_issue" {
  name   = "kubernetes-issue"
  policy = <<EOT
path "${vault_mount.pki_kubernetes.path}/issue/*" {
  capabilities = [ "read", "create", "update" ]
}
EOT
}

resource "vault_policy" "etcd_client_issue" {
  name   = "etcd-client-issue"
  policy = <<EOT
path "${vault_mount.pki_etcd.path}/issue/client" {
  capabilities = [ "read", "create", "update" ]
}
EOT
}

resource "vault_approle_auth_backend_role" "kubernetes" {
  backend        = vault_auth_backend.approle.path
  role_name      = "${var.cluster_id}-node-kubernetes"
  token_policies = [vault_policy.kubernetes_issue.name, vault_policy.etcd_client_issue.name, vault_policy.front-proxy_issue.name]
}

# Generate moved blocks for all of these resources to move them under module.vault_k8s

