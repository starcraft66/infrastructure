data "cloudflare_zones" "tdude_co" {
  filter {
    name = "tdude.co"
  }
}

resource "cloudflare_record" "ftb-ultimate-srv" {
  zone_id = lookup(data.cloudflare_zones.tdude_co.zones[0], "id")
  name    = "_minecraft._tcp.ftb-ultimate"
  data {
    name     = "ftb-ultimate"
    port     = 12351
    priority = 1
    proto    = "_tcp"
    service  = "_minecraft"
    target   = "ftb-ultimate.k8s.235.${lookup(data.cloudflare_zones.tdude_co.zones[0], "name")}"
    weight   = 1
  }
  type    = "SRV"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "ftb-ultimate-v4" {
  zone_id = lookup(data.cloudflare_zones.tdude_co.zones[0], "id")
  name    = "ftb-ultimate.k8s.235"
  value   = "24.225.136.165"
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "ftb-ultimate-v6" {
  zone_id = lookup(data.cloudflare_zones.tdude_co.zones[0], "id")
  name    = "ftb-ultimate.k8s.235"
  value   = "2a10:4741:36:32:3::c0da"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}
