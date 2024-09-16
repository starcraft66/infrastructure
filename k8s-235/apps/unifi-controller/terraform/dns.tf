data "cloudflare_zones" "tdude_co" {
  filter {
    name = "tdude.co"
  }
}

resource "cloudflare_record" "unifi" {
  zone_id = lookup(data.cloudflare_zones.tdude_co.zones[0], "id")
  name    = "unifi"
  content = "traefik.k8s.235.${lookup(data.cloudflare_zones.tdude_co.zones[0], "name")}"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "unifi-235" {
  zone_id = lookup(data.cloudflare_zones.tdude_co.zones[0], "id")
  name    = "unifi.235"
  content = "unifi.${lookup(data.cloudflare_zones.tdude_co.zones[0], "name")}"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "unifi-260" {
  zone_id = lookup(data.cloudflare_zones.tdude_co.zones[0], "id")
  name    = "unifi.260"
  content = "unifi.${lookup(data.cloudflare_zones.tdude_co.zones[0], "name")}"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "unifi-305-1700" {
  zone_id = lookup(data.cloudflare_zones.tdude_co.zones[0], "id")
  name    = "unifi.305-1700"
  content = "unifi.${lookup(data.cloudflare_zones.tdude_co.zones[0], "name")}"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}