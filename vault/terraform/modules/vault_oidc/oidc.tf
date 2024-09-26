resource "vault_auth_backend" "userpass" {
  type = "userpass"
  path = "userpass"
}

resource "vault_identity_oidc_assignment" "allowed_users" {
  name = "my-assignment"
  entity_ids = [
    vault_identity_entity.tristan.id,
    vault_identity_entity.anon.id,
  ]
  group_ids = [
    vault_identity_group.admins.id,
  ]
}

resource "vault_identity_entity" "tristan" {
  name = "tristan"
  metadata = {
    name  = "Tristan Gosselin-Hane"
    email = "starcraft66@gmail.com"
  }
}

resource "vault_identity_entity" "anon" {
  name = "anon"
  metadata = {
    name  = "Anonymous User"
    email = "anonymous@tdude.co"
  }
}

resource "vault_identity_entity_alias" "tristan" {
  name           = "tristan"
  mount_accessor = vault_auth_backend.userpass.accessor
  canonical_id   = vault_identity_entity.tristan.id
}

resource "vault_identity_entity_alias" "anon" {
  name           = "anon"
  mount_accessor = vault_auth_backend.userpass.accessor
  canonical_id   = vault_identity_entity.anon.id
}

resource "vault_identity_group" "admins" {
  name              = "admins"
  type              = "internal"
  member_entity_ids = [vault_identity_entity.tristan.id]

  metadata = {
    version = "2"
  }
}

resource "vault_identity_oidc" "server" {
  # If issuer not set, Vault's api_addr will be used.
  # Which is exacly what we want.
}

resource "vault_identity_oidc_scope" "groups" {
  name        = "groups"
  template    = <<EOT
{
  "groups": {{identity.entity.groups.names}} 
}
EOT
  description = "Vault OIDC Groups Scope"
}

resource "vault_identity_oidc_scope" "profile" {
  name        = "profile"
  template    = <<EOT
{
    "name": {{identity.entity.name}}
}
EOT
  description = "Vault OIDC user Scope"
}

resource "vault_identity_oidc_scope" "email" {
  name        = "email"
  template    = <<EOT
{
    "email": {{identity.entity.metadata.email}},
    "email_verified": true
}
EOT
  description = "Vault OIDC user Scope"
}

resource "vault_identity_oidc_provider" "vault" {
  name               = "default"
  https_enabled      = true
  allowed_client_ids = ["*"]
  scopes_supported = [
    vault_identity_oidc_scope.profile.name,
    vault_identity_oidc_scope.groups.name,
    vault_identity_oidc_scope.email.name,
  ]
}

# Generate moved blocks for all of these resources to move them under module.vault_oidc


