data "cloudflare_zones" "tdude_co" {
  filter {
    name = "tdude.co"
  }
}

resource "cloudflare_record" "gtnh-srv" {
  zone_id = lookup(data.cloudflare_zones.tdude_co.zones[0], "id")
  name    = "_minecraft._tcp.gtnh"
  data {
    name     = "gtnh"
    port     = 3423
    priority = 1
    proto    = "_tcp"
    service  = "_minecraft"
    # target   = "gtnh.k8s.235.${lookup(data.cloudflare_zones.tdude_co.zones[0], "name")}"
    target   = "fiki.dev"
    weight   = 1
  }
  type    = "SRV"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "gtnh-v4" {
  zone_id = lookup(data.cloudflare_zones.tdude_co.zones[0], "id")
  name    = "gtnh.k8s.235"
  value   = "24.225.136.165"
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "gtnh-v6" {
  zone_id = lookup(data.cloudflare_zones.tdude_co.zones[0], "id")
  name    = "gtnh.k8s.235"
  value   = "2a10:4741:36:32:3::8de1"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}
