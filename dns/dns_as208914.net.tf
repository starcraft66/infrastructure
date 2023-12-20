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
  value   = "2001:19f0:b001:9ad:5400:4ff:fe8e:d98e"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "yyz-r1_backdoor_as208914_net-A" {
  zone_id = cloudflare_zone.as208914_net.id
  name    = "yyz-r1.backdoor"
  value   = "137.220.55.38"
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "ams-r1_as208914_net-AAAA" {
  zone_id = cloudflare_zone.as208914_net.id
  name    = "ams-r1"
  value   = "2a10:4741:38::1"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "ams-r1_backdoor_as208914_net-AAAA" {
  zone_id = cloudflare_zone.as208914_net.id
  name    = "ams-r1.backdoor"
  value   = "2a0c:9a40:1072::706"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "ams-r1_backdoor_as208914_net-A" {
  zone_id = cloudflare_zone.as208914_net.id
  name    = "ams-r1.backdoor"
  value   = "193.148.248.216"
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "mail" {
  zone_id  = cloudflare_zone.as208914_net.id
  name     = "as208914.net"
  value    = "stone.tdude.co"
  type     = "MX"
  priority = "10"
  ttl      = 1
  proxied  = false
}

resource "cloudflare_record" "geo_as208914_net-CNAME" {
  zone_id = cloudflare_zone.as208914_net.id
  name    = "geo"
  value   = "starcraft66.github.io"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "dkim_as208914_net" {
  zone_id = cloudflare_zone.as208914_net.id
  name    = "201608._domainkey"
  value   = "v=DKIM1; k=rsa; s=email; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAyxeUzz+l0IQZG0Nn7CJgroSmazG4p0azC1nyydwkZ9nKQ0H5en9dNClX8Epw6onyn8sqYpQQoBhW/TgMBjvmFZp9zOZxddCxgR3vAckeTUtiLR7F4hI339xyXhQgnVsQNCglTGaz27ca/WXVByp13A5cqXnu1V7r+9xVlteXrs2OdCehtDRnRfWBZR13yifeKTLUWJ444T5K4wjqRf5oApJKTcLi6S+fVK3eDJ2hm0Yvre1vMrJhz+zoLvUNyujxZAlkx+Me/bFxqTu3dFSUo8ySaWaNhBPu1CePQ4Jc+1AoRAUOz2sx5SyT12s/0dBa3gJnP2SKCzHZTjERNfiPHwIDAQAB"
  type    = "TXT"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "dkim_as208914_mail" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "mail._domainkey"
  value   = "v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAzxbexjYz/71o/Ci7XIofTWZNEphc/0a4RVzVV3wX7tocZISGew2w+6+bPWScJJ7SsHSHyd8q99EgWl6XZJQu8otMOJJa5EPOZ/UolEB7z9zS1nK2eq/BQMLJfrT0yeti73fe2qsphpEfKoMxMTBF73y/Gn+A6uC12/CCgPncioR6kwAdbl5S/vZ+0Vt0Kyx0PpXgF/mjaEuUGHbTtA7cqdOdDFVjXVI6/+J7qVhV8AYyAebbS/l0/SHoFHQpxQRNr4iZ71KwNEXCewANNqoiGBXLzIH9+N/obZ+qWaF1siUVUfPZwG2ahGgM3QZENySX+N6/7jRdl+MZT5CROLjVgQIDAQAB"
  type    = "TXT"
  ttl     = 1
  proxied = false
}