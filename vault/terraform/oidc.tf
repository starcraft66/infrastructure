resource "vault_auth_backend" "userpass" {
  type = "userpass"
  path = "userpass"
}

resource "vault_policy" "oidc_auth" {
  name   = "oidc-auth"
  policy = <<-EOT
    path "identity/oidc/provider/default/authorize" {
      capabilities = [ "read" ]
    }
  EOT
}

resource "vault_identity_oidc_assignment" "test" {
  name = "my-assignment"
  entity_ids = [
    vault_identity_entity.tristan.id
  ]
  group_ids = [
    vault_identity_group.admins.id
  ]
}

resource "vault_identity_entity" "tristan" {
  name     = "tristan"
  policies = ["test"]
  metadata = {
    name  = "Tristan"
    email = "starcraft66@gmail.com"
  }
}

resource "vault_identity_entity_alias" "tristan" {
  name           = "tristan"
  mount_accessor = "auth_userpass_1fabbaea"
  canonical_id   = vault_identity_entity.tristan.id
}

resource "vault_identity_group" "admins" {
  name              = "admins"
  type              = "internal"
  policies          = ["dev", "test"]
  member_entity_ids = [vault_identity_entity.tristan.id]

  metadata = {
    version = "2"
  }
}

resource "vault_identity_oidc_client" "grafana-k8s-235-1" {
  name        = "grafana-k8s-235-1"
  client_type = "public"
  redirect_uris = [
    "https://monitoring.tdude.co/login/generic_oauth",
  ]
  assignments = [
    vault_identity_oidc_assignment.test.name
  ]
  id_token_ttl     = 2400
  access_token_ttl = 7200
}

resource "vault_identity_oidc_client" "argocd-k8s-235-1" {
  name        = "argocd-k8s-235-1"
  client_type = "public"
  redirect_uris = [
    "https://gitops.tdude.co/api/dex/callback",
  ]
  assignments = [
    vault_identity_oidc_assignment.test.name
  ]
  id_token_ttl     = 2400
  access_token_ttl = 7200
}

resource "vault_identity_oidc_client" "oauth2-proxy-k8s-235-1" {
  name        = "oauth2-proxy-k8s-235-1"
  client_type = "public"
  redirect_uris = [
    "https://auth.k8s.235.tdude.co/oauth2/callback",
  ]
  assignments = [
    vault_identity_oidc_assignment.test.name
  ]
  id_token_ttl     = 2400
  access_token_ttl = 7200
}

resource "vault_identity_oidc_client" "kubernetes-k8s-235-1" {
  name        = "k8s-235-1"
  client_type = "public"
  redirect_uris = [
    "http://localhost:8000",
    "http://localhost:18000"
  ]
  assignments = [
    vault_identity_oidc_assignment.test.name
  ]
  id_token_ttl     = 2400
  access_token_ttl = 7200
}

resource "vault_identity_oidc" "server" {
  issuer = "https://vault.235.tdude.co"
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

resource "vault_identity_oidc_scope" "user" {
  name        = "user"
  template    = <<EOT
{
    "username": {{identity.entity.name}}
}
EOT
  description = "Vault OIDC user Scope"
}

resource "vault_identity_oidc_scope" "email" {
  name        = "email"
  template    = <<EOT
{
    "email": {{identity.entity.metadata.email}}
}
EOT
  description = "Vault OIDC user Scope"
}

resource "vault_identity_oidc_provider" "vault" {
  name               = "default"
  https_enabled      = true
  allowed_client_ids = ["*"]
  scopes_supported = [
    vault_identity_oidc_scope.user.name,
    vault_identity_oidc_scope.groups.name,
    vault_identity_oidc_scope.email.name,
  ]
}