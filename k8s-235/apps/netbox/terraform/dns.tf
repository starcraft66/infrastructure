data "cloudflare_zones" "tdude_co" {
  filter {
    name = "tdude.co"
  }
}

resource "cloudflare_record" "netbox" {
  zone_id = lookup(data.cloudflare_zones.tdude_co.zones[0], "id")
  name    = "netbox"
  value   = "traefik.k8s.235.${lookup(data.cloudflare_zones.tdude_co.zones[0], "name")}"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}
