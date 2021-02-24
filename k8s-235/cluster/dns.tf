data "cloudflare_zones" "tdude_co" {
  filter {
    name = "tdude.co"
  }
}

resource "cloudflare_record" "k8s-node-aaaa" {
  count   = var.node_count
  zone_id = lookup(data.cloudflare_zones.tdude_co.zones[0], "id")
  name    = "node${count.index + 1}.k8s.235"
  value   = "2607:fa48:6ed8:8a54:100::${count.index + 10}"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}