data "cloudflare_zones" "tdude_co" {
  filter {
    name = "tdude.co"
  }
}

resource "cloudflare_record" "beyondroastbeef-srv" {
  zone_id = lookup(data.cloudflare_zones.tdude_co.zones[0], "id")
  name    = "_minecraft._tcp.beyondroastbeef"
  data {
    name     = "beyondroastbeef"
    port     = 12348
    priority = 1
    proto    = "_tcp"
    service  = "_minecraft"
    target   = "beyondroastbeef.k8s.235.${lookup(data.cloudflare_zones.tdude_co.zones[0], "name")}"
    weight   = 1
  }
  type    = "SRV"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "beyondroastbeef-v4" {
  zone_id = lookup(data.cloudflare_zones.tdude_co.zones[0], "id")
  name    = "beyondroastbeef.k8s.235"
  content = "24.225.136.165"
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "beyondroastbeef-v6" {
  zone_id = lookup(data.cloudflare_zones.tdude_co.zones[0], "id")
  name    = "beyondroastbeef.k8s.235"
  content = "2a10:4741:36:32:3::9"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}
