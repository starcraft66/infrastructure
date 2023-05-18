data "cloudflare_zones" "tdude_co" {
  filter {
    name = "tdude.co"
  }
}

resource "cloudflare_record" "ftb-academy-srv" {
  zone_id = lookup(data.cloudflare_zones.tdude_co.zones[0], "id")
  name    = "_minecraft._tcp.ftb-academy"
  data {
    name     = "ftb-academy"
    port     = 12351
    priority = 1
    proto    = "_tcp"
    service  = "_minecraft"
    target   = "ftb-academy.k8s.235.${lookup(data.cloudflare_zones.tdude_co.zones[0], "name")}"
    weight   = 1
  }
  type    = "SRV"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "ftb-academy-v4" {
  zone_id = lookup(data.cloudflare_zones.tdude_co.zones[0], "id")
  name    = "ftb-academy.k8s.235"
  value   = "24.225.136.165"
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "ftb-academy-v6" {
  zone_id = lookup(data.cloudflare_zones.tdude_co.zones[0], "id")
  name    = "ftb-academy.k8s.235"
  value   = "2a10:4741:36:8a54:3::6"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}
