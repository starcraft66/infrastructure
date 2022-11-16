terraform {
  required_version = ">= 0.13"
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.9.11"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "3.28.0"
    }
  }
}
