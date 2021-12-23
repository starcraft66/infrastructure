terraform {
  required_version = ">= 0.13"
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.9.3"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "3.6.0"
    }
  }
}
