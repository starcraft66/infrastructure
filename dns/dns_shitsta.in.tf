resource "cloudflare_zone" "shitsta_in" {
  name = "shitsta.in"
  account = {
    id = "2b4b7b075ea5f723e423aaee08c09e4d"
  }
}

resource "cloudflare_dns_record" "shitsta_in-4f4799fae5fde1ad79648fc0d33c7df2" {
  zone_id = cloudflare_zone.shitsta_in.id
  name    = "shitsta.in"
  content = "158.69.211.121"
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_dns_record" "www_shitsta_in-3af6dcfe4bbd6279024e017eedc4c8c9" {
  zone_id = cloudflare_zone.shitsta_in.id
  name    = "www"
  content = "158.69.211.121"
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_dns_record" "shitsta_in-9b9b29824b41802c9e8a16ac226214d1" {
  zone_id = cloudflare_zone.shitsta_in.id
  name    = "shitsta.in"
  content = "2607:5300:201:3100::7e8c"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_dns_record" "www_shitsta_in-c1590f325d584763e05763b0d356ea80" {
  zone_id = cloudflare_zone.shitsta_in.id
  name    = "www"
  content = "2607:5300:201:3100::7e8c"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_dns_record" "shitsta_in-32cf1e78d6ddd4f54f0929ede371c292" {
  zone_id = cloudflare_zone.shitsta_in.id
  name    = "shitsta.in"
  data = {
    flags = 0
    tag   = "iodef"
    value = "mailto:tristan@tdude.co"
  }
  type    = "CAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_dns_record" "shitsta_in-878cb5e726ea223548d09f36d9e5cfbd" {
  zone_id = cloudflare_zone.shitsta_in.id
  name    = "shitsta.in"
  data = {
    flags = 0
    tag   = "issue"
    value = "letsencrypt.org"
  }
  type    = "CAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_dns_record" "shitsta_in-e6d6143882cd93d8830d3fd6d2fdbd3e" {
  zone_id = cloudflare_zone.shitsta_in.id
  name    = "shitsta.in"
  content = "google-site-verification=_Ka8uZyZXbmgMpaEZU3f9mKWbeLcihoRMcZUtYYIlGw"
  type    = "TXT"
  ttl     = 1
  proxied = false
}

