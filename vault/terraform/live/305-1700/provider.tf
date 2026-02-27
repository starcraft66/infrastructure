provider "vault" {
  address = "https://vault.305-1700.tdude.co"
}

provider "pocketid" {
  base_url = "https://id.305-1700.tdude.co"
}

terraform {
  required_providers {
    pocketid = {
      source  = "trozz/pocketid"
      version = "0.1.7"
    }
  }
}
