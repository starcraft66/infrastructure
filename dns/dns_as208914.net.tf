resource "cloudflare_zone" "as208914_net" {
  zone       = "as208914.net"
  account_id = "2b4b7b075ea5f723e423aaee08c09e4d"
}

resource "cloudflare_zone_dnssec" "as208914_net_dnssec" {
  zone_id = cloudflare_zone.as208914_net.id
}

resource "cloudflare_record" "lg_as208914_net-AAAA" {
  zone_id = cloudflare_zone.as208914_net.id
  name    = "lg"
  value   = "2a10:4741:32::1"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "yyz-r1_as208914_net-AAAA" {
  zone_id = cloudflare_zone.as208914_net.id
  name    = "yyz-r1"
  value   = "2a10:4741:33::1"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "yyz-r1_backdoor_as208914_net-AAAA" {
  zone_id = cloudflare_zone.as208914_net.id
  name    = "yyz-r1.backdoor"
  value   = "2001:19f0:b001:390:5400:3ff:fed8:2ff7"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}
resource "cloudflare_record" "yyz-r1_backdoor_as208914_net-A" {
  zone_id = cloudflare_zone.as208914_net.id
  name    = "yyz-r1.backdoor"
  value   = "155.138.154.43"
  type    = "A"
  ttl     = 1
  proxied = false
}