data "cloudflare_zones" "tdude_co" {
  filter {
    name = "tdude.co"
  }
}

resource "cloudflare_record" "traefik-v4" {
  zone_id = lookup(data.cloudflare_zones.tdude_co.zones[0], "id")
  name    = "traefik.k8s.235"
  value   = "24.225.136.165"
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "traefik-v6" {
  zone_id = lookup(data.cloudflare_zones.tdude_co.zones[0], "id")
  name    = "traefik.k8s.235"
  value   = "2a10:4741:36:32:3::2"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "traefik-dashboard" {
  zone_id = lookup(data.cloudflare_zones.tdude_co.zones[0], "id")
  name    = "dashboard.traefik.k8s.235"
  value   = "traefik.k8s.235.${lookup(data.cloudflare_zones.tdude_co.zones[0], "name")}"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "traefik-forward-auth" {
  zone_id = lookup(data.cloudflare_zones.tdude_co.zones[0], "id")
  name    = "auth.k8s.235"
  value   = "traefik.k8s.235.${lookup(data.cloudflare_zones.tdude_co.zones[0], "name")}"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}
