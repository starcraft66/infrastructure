resource "cloudflare_zone" "nerdsin_space" {
  zone = "nerdsin.space"
  # id = "f51e4e810b96efbadb972187038375d5"
}

resource "cloudflare_record" "turn_nerdsin_space-772814e8fbfef2c39c8977e269d3b3aa" {
  zone_id = cloudflare_zone.nerdsin_space.id
  name    = "turn"
  value   = "bedrock.tdude.co"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "nerdsin_space-3ac2691767564a8029f9dcaefe7c7b01" {
  zone_id = cloudflare_zone.nerdsin_space.id
  name    = "nerdsin.space"
  value   = "traefik.bedrock.tdude.co"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "nerdsin_space-b40126e8c919a22ec1d75a8090179a23" {
  zone_id  = cloudflare_zone.nerdsin_space.id
  name     = "nerdsin.space"
  value    = "cgbpi.com"
  type     = "MX"
  priority = "10"
  ttl      = 1
  proxied  = false
}

resource "cloudflare_record" "minio_nerdsin_space_A" {
  zone_id = cloudflare_zone.nerdsin_space.id
  name    = "minio"
  value   = "traefik.bedrock.tdude.co"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "_github-challenge-nerdsinspace_nerdsin_space_TXT" {
  zone_id = cloudflare_zone.nerdsin_space.id
  name    = "_github-challenge-nerdsinspace"
  value   = "d792693e34"
  type    = "TXT"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "_matrix__tcp_nerdsin_space-aa2b554a2832c865d14945123b62160a" {
  zone_id = cloudflare_zone.nerdsin_space.id
  name    = "_matrix._tcp"
  data    = {
    name     = "nerdsin.space"
    port     = 443
    priority = 10
    proto    = "_tcp"
    service  = "_matrix"
    target   = "nerdsin.space"
    weight   = 0
  }
  type    = "SRV"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "_matrix__tcp_staging_nerdsin_space-6f7da27c1882659176af5273753c823d" {
  zone_id = cloudflare_zone.nerdsin_space.id
  name    = "_matrix._tcp.staging"
  data    = {
    name     = "staging"
    port     = 443
    priority = 1
    proto    = "_tcp"
    service  = "_matrix"
    target   = "staging.nerdsin.space"
    weight   = 1
  }
  type    = "SRV"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "_minecraft__tcp_nerdsin_space-d8276c70aea17f359f136bc7dffd000c" {
  zone_id = cloudflare_zone.nerdsin_space.id
  name    = "_minecraft._tcp"
  data    = {
    name      = "nerdsin.space"
    port      = 25565
    priority  = 10
    proto     = "_tcp"
    service   = "_minecraft"
    target    = "mc.fiki.dev"
    weight    = 10
  }
  type    = "SRV"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "mail__domainkey_nerdsin_space-83e7837cc7cae988e3e41d87514012ba" {
  zone_id = cloudflare_zone.nerdsin_space.id
  name    = "mail._domainkey"
  value   = "v=DKIM1;p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAm0gvmm17deOjoiGJXoHh8qx3QVyf7IZzYQwYVwSlXqGQSJCzWmA56ij4kAbd3nmCm7dOauG6L/ftMsAhzMhtoI1fyFSEY6ZYnlLoQQMWk6QltYyZtfHhCgsTzhSvh/9VLhTY8knEXw9ejKCY3uUpWRk4RGXWTriz69zYP49yrmLqPpwTIyuz7gWlyIp21D4B2C4GmABiBJT/cEeEYYuUl53OXjW+4tXMMO+gfznm2zR3/1jwncNFSi1ESRIV3IDVyAJztqpoZXjZmILLpnos2T+bS7slWOR5ig1qi8+TQugexmCMbKbqhSob7KHleNBwu/LXaxYi5MJPJO7PgY+rwwIDAQAB"
  type    = "TXT"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "nerdsin_space-a820eaf032b56421482eda61544cff2b" {
  zone_id = cloudflare_zone.nerdsin_space.id
  name    = "nerdsin.space"
  value   = "google-site-verification=D7t1NXuj14XKtlXk0sZ5d1JTsxph4BKdrfI9vv0HY-k"
  type    = "TXT"
  ttl     = 1
  proxied = false
}

