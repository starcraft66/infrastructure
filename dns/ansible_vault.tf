data "ansiblevault_path" "cf_dns_token" {
  path = "group_vars/all/vault.yml"
  key  = "vault_cloudflare_dns_token"
}

