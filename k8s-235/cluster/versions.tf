terraform {
  required_version = ">= 0.13"
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.7.4"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "2.26.1"
    }
  }
}
