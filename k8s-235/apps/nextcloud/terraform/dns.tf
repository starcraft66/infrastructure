data "cloudflare_zones" "tdude_co" {
  filter {
    name = "tdude.co"
  }
}

resource "cloudflare_record" "nextcloud" {
  zone_id = lookup(data.cloudflare_zones.tdude_co.zones[0], "id")
  name    = "cloud"
  value   = "traefik.k8s.235.${lookup(data.cloudflare_zones.tdude_co.zones[0], "name")}"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}

# Cause the nextcloud android app sucks and cant handle ipv6 properly
resource "cloudflare_record" "nextcloud-v4" {
  zone_id = lookup(data.cloudflare_zones.tdude_co.zones[0], "id")
  name    = "cloud4"
  value   = "24.225.136.165"
  type    = "A"
  ttl     = 1
  proxied = false
}
