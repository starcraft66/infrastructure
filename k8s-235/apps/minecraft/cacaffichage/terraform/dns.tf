data "cloudflare_zones" "tdude_co" {
  filter {
    name = "tdude.co"
  }
}

resource "cloudflare_record" "cacaffichage-srv" {
  zone_id = lookup(data.cloudflare_zones.tdude_co.zones[0], "id")
  name    = "_minecraft._tcp.cacaffichage"
  data    = {
    name      = "cacaffichage"
    port      = 12345
    priority  = 1
    proto     = "_tcp"
    service   = "_minecraft"
    target    = "cacaffichage.k8s.235.${lookup(data.cloudflare_zones.tdude_co.zones[0], "name")}"
    weight    = 1
  }
  type    = "SRV"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "cacaffichage-v4" {
  zone_id = lookup(data.cloudflare_zones.tdude_co.zones[0], "id")
  name    = "cacaffichage.k8s.235"
  value   = "24.225.136.165"
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "cacaffichage-v6" {
  zone_id = lookup(data.cloudflare_zones.tdude_co.zones[0], "id")
  name    = "cacaffichage.k8s.235"
  value   = "2607:fa48:6ed8:8a54:3::2"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}