resource "vault_auth_backend" "approle" {
  type = "approle"
  path = "approle"
}

# Generate moved blocks for all of these resources to move them under module.vault_k8s

