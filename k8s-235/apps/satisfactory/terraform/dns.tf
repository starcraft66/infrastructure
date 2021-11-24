data "cloudflare_zones" "tdude_co" {
  filter {
    name = "tdude.co"
  }
}

resource "cloudflare_record" "satisfactory-v4" {
  zone_id = lookup(data.cloudflare_zones.tdude_co.zones[0], "id")
  name    = "satisfactory"
  value   = "24.225.136.165"
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "satisfactory-v6" {
  zone_id = lookup(data.cloudflare_zones.tdude_co.zones[0], "id")
  name    = "satisfactory"
  value   = "2607:fa48:6ed8:8a54:3::2"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}
