provider "ansiblevault" {
  root_folder = ".."
}

provider "cloudflare" {
  api_token = data.ansiblevault_path.cf_dns_token.value
}
