provider "vault" {
  address = "https://vault.235.tdude.co"
  token   = ephemeral.sops_file.secrets.data["VAULT_TOKEN"]
}

provider "pocketid" {
  base_url  = "https://id.235.tdude.co"
  api_token = ephemeral.sops_file.secrets.data["POCKETID_API_TOKEN"]
}

ephemeral "sops_file" "secrets" {
  source_file = "secrets.yaml"
}

terraform {
  required_providers {
    pocketid = {
      source  = "trozz/pocketid"
      version = "2.5.0"
    }
    sops = {
      source  = "carlpett/sops"
      version = "1.4.1"
    }
  }
}
