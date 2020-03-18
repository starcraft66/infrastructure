resource "cloudflare_zone" "cgbpi_com" {
  zone = "cgbpi.com"
  # id = "6322bae6b62fcf2868a77cc564c6d045"
}

resource "cloudflare_record" "cgbpi_com-eb568133c231b70e6464374bb646acd9" {
  zone_id = cloudflare_zone.cgbpi_com.id
  name    = "cgbpi.com"
  value   = "167.114.177.177"
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "cgbpi_com-57901067a65d87a9f31c4ddb3e28ccb5" {
  zone_id = cloudflare_zone.cgbpi_com.id
  name    = "cgbpi.com"
  value   = "2607:5300:60:873e:9::2"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "webmail_cgbpi_com-0395f08f4989e2e0e3eedad5a7d4ef6e" {
  zone_id = cloudflare_zone.cgbpi_com.id
  name    = "webmail"
  value   = "cgbpi.com"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "www_cgbpi_com-1afc57880af38efcf6a04b38e6c637c8" {
  zone_id = cloudflare_zone.cgbpi_com.id
  name    = "www"
  value   = "cgbpi.com"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "cgbpi_com-d8898859227d6ceb685fea81dc383140" {
  zone_id  = cloudflare_zone.cgbpi_com.id
  name     = "cgbpi.com"
  value    = "cgbpi.com"
  type     = "MX"
  priority = "10"
  ttl      = 1
  proxied  = false
}

resource "cloudflare_record" "cgbpi_com-6e38353eb3b2044a135b37c5ad5008d7" {
  zone_id = cloudflare_zone.cgbpi_com.id
  name    = "cgbpi.com"
  value   = "google-site-verification=Vi3jafHpyKRlIupWT2vvw3hRqmBCRBAFizblmX-2bZ8"
  type    = "TXT"
  ttl     = 1
  proxied = false
}

