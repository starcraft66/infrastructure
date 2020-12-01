resource "cloudflare_zone" "trs_tn" {
  zone = "trs.tn"
  # id = "b7c58ff85f09ba3a7aeaa231c216dd84"
}

resource "cloudflare_record" "trs_tn-d7e17404cdb4a9dd8d805719fbaaa715" {
  zone_id = cloudflare_zone.trs_tn.id
  name    = "trs.tn"
  value   = "158.69.211.121"
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "u_trs_tn-227a457f9f3e460fa28db2a8602531a7" {
  zone_id = cloudflare_zone.trs_tn.id
  name    = "u"
  value   = "158.69.211.121"
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "www_trs_tn-8b7752d9574918a5c2fbc392ad7fb48c" {
  zone_id = cloudflare_zone.trs_tn.id
  name    = "www"
  value   = "158.69.211.121"
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "l_trs_tn-2c9abf3ea4a6e9cc67e15c87e8334761" {
  zone_id = cloudflare_zone.trs_tn.id
  name    = "l"
  value   = "traefik.bedrock.tdude.co"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "trs_tn-81b7adb99911b38f1c79a305642415e6" {
  zone_id = cloudflare_zone.trs_tn.id
  name    = "trs.tn"
  value   = "2607:5300:201:3100::7e8c"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "u_trs_tn-ff8675924a9d66fe0fe650c6dd497e96" {
  zone_id = cloudflare_zone.trs_tn.id
  name    = "u"
  value   = "2607:5300:201:3100::7e8c"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "www_trs_tn-0cd9059f357d8f5bb18ad80a394f8943" {
  zone_id = cloudflare_zone.trs_tn.id
  name    = "www"
  value   = "2607:5300:201:3100::7e8c"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "trs_tn-0983f01d1ae34286622cd0090b66658b" {
  zone_id = cloudflare_zone.trs_tn.id
  name    = "trs.tn"
  data    = {
    flags = 0
    tag   = "iodef"
    value = "mailto:tristan@tdude.co"
  }
  type    = "CAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "trs_tn-87597a3b0dcc0efc6ba5385ab496bb0d" {
  zone_id = cloudflare_zone.trs_tn.id
  name    = "trs.tn"
  data    = {
    flags = 0
    tag   = "issue"
    value = "letsencrypt.org"
  }
  type    = "CAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "trs_tn-0e6675ddb050a442efc347307b08a192" {
  zone_id  = cloudflare_zone.trs_tn.id
  name     = "trs.tn"
  value    = "stone.tdude.co"
  type     = "MX"
  priority = "1"
  ttl      = 1
  proxied  = false
}

resource "cloudflare_record" "trs_tn-1e6f1c259d2db7a9bef9f399553fbfe4" {
  zone_id = cloudflare_zone.trs_tn.id
  name    = "trs.tn"
  value   = "google-site-verification=GTcTyAx0ER2FJMDVDawybXT961R2EXNm85lFEAc1osA"
  type    = "TXT"
  ttl     = 1
  proxied = false
}

