resource "vault_mount" "pki_kubernetes" {
  path                      = "${var.cluster_id}/pki/kubernetes"
  type                      = "pki"
  default_lease_ttl_seconds = 3600
  max_lease_ttl_seconds     = 315360000 # 32 Days
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
  token_policies = [vault_policy.kubernetes_issue.name, vault_policy.etcd_client_issue.name]
}
