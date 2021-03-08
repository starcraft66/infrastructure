data "cloudflare_zones" "nhackindustries_com" {
  filter {
    name = "nhackindustries.com"
  }
}

resource "cloudflare_record" "elasticsearch" {
  zone_id = lookup(data.cloudflare_zones.nhackindustries_com.zones[0], "id")
  name    = "elasticsearch.elk"
  value   = "traefik.k8s.235.tdude.co"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "kibana" {
  zone_id = lookup(data.cloudflare_zones.nhackindustries_com.zones[0], "id")
  name    = "elk"
  value   = "traefik.k8s.235.tdude.co"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}