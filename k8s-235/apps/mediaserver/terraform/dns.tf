data "cloudflare_zones" "tdude_co" {
  filter {
    name = "tdude.co"
  }
}

resource "cloudflare_record" "mediaserver-plex" {
  zone_id = lookup(data.cloudflare_zones.tdude_co.zones[0], "id")
  name    = "plex"
  value   = "traefik.k8s.235.${lookup(data.cloudflare_zones.tdude_co.zones[0], "name")}"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "mediaserver-sonarr" {
  zone_id = lookup(data.cloudflare_zones.tdude_co.zones[0], "id")
  name    = "sonarr"
  value   = "traefik.k8s.235.${lookup(data.cloudflare_zones.tdude_co.zones[0], "name")}"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "mediaserver-radarr" {
  zone_id = lookup(data.cloudflare_zones.tdude_co.zones[0], "id")
  name    = "radarr"
  value   = "traefik.k8s.235.${lookup(data.cloudflare_zones.tdude_co.zones[0], "name")}"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "mediaserver-lidarr" {
  zone_id = lookup(data.cloudflare_zones.tdude_co.zones[0], "id")
  name    = "lidarr"
  value   = "traefik.k8s.235.${lookup(data.cloudflare_zones.tdude_co.zones[0], "name")}"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "mediaserver-jackett" {
  zone_id = lookup(data.cloudflare_zones.tdude_co.zones[0], "id")
  name    = "jackett"
  value   = "traefik.k8s.235.${lookup(data.cloudflare_zones.tdude_co.zones[0], "name")}"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "mediaserver-qbittorrent" {
  zone_id = lookup(data.cloudflare_zones.tdude_co.zones[0], "id")
  name    = "qbittorrent"
  value   = "traefik.k8s.235.${lookup(data.cloudflare_zones.tdude_co.zones[0], "name")}"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "mediaserver-tautulli" {
  zone_id = lookup(data.cloudflare_zones.tdude_co.zones[0], "id")
  name    = "tautulli"
  value   = "traefik.k8s.235.${lookup(data.cloudflare_zones.tdude_co.zones[0], "name")}"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "mediaserver-organizr" {
  zone_id = lookup(data.cloudflare_zones.tdude_co.zones[0], "id")
  name    = "mediaserver"
  value   = "traefik.k8s.235.${lookup(data.cloudflare_zones.tdude_co.zones[0], "name")}"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}