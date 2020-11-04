
terraform {
  required_version = ">= 0.13"
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
    ansiblevault = {
      source = "MeilleursAgents/ansiblevault"
    }
  }
}
