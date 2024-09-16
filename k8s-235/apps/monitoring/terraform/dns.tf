data "cloudflare_zones" "tdude_co" {
  filter {
    name = "tdude.co"
  }
}

resource "cloudflare_record" "monitoring-grafana" {
  zone_id = lookup(data.cloudflare_zones.tdude_co.zones[0], "id")
  name    = "monitoring"
  content = "traefik.k8s.235.${lookup(data.cloudflare_zones.tdude_co.zones[0], "name")}"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "monitoring-prometheus" {
  zone_id = lookup(data.cloudflare_zones.tdude_co.zones[0], "id")
  name    = "prometheus.monitoring"
  content = "traefik.k8s.235.${lookup(data.cloudflare_zones.tdude_co.zones[0], "name")}"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "monitoring-alertmanager" {
  zone_id = lookup(data.cloudflare_zones.tdude_co.zones[0], "id")
  name    = "alertmanager.monitoring"
  content = "traefik.k8s.235.${lookup(data.cloudflare_zones.tdude_co.zones[0], "name")}"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "monitoring-pyrra" {
  zone_id = lookup(data.cloudflare_zones.tdude_co.zones[0], "id")
  name    = "pyrra.monitoring"
  content = "traefik.k8s.235.${lookup(data.cloudflare_zones.tdude_co.zones[0], "name")}"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}
