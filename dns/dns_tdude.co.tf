resource "cloudflare_zone" "tdude_co" {
  zone       = "tdude.co"
  account_id = "2b4b7b075ea5f723e423aaee08c09e4d"
  # id = "c802e5f57a27af705373d5d3570649f0"
}

resource "cloudflare_record" "cadvisor_bedrock_tdude_co-db5de91b27b5078488d6d32f51e08fdc" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "cadvisor.bedrock"
  value   = "traefik.bedrock.tdude.co"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "fleetfoot-ilo_tdude_co" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "fleetfoot-ilo.235"
  value   = "2a10:4741:36:24:29c:2ff:fea5:346c"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "stormfeather-ilo_tdude_co" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "stormfeather-ilo.235"
  value   = "2a10:4741:36:24:b6b5:2fff:feef:9766"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "sassaflash-ilo_tdude_co" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "sassaflash-ilo.235"
  value   = "2a10:4741:36:24:b6b5:2fff:fee9:cd36"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "k8s-235" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "k8s.235"
  value   = "2a10:4741:36:29::8:1"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "registry_tdude_co-CNAME" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "registry"
  value   = "traefik.bedrock.tdude.co"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "git_tdude_co-15e863f9cc46997d6dff0c6f6d9d6b8b" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "git"
  value   = "traefik.bedrock.tdude.co"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "lolisafe_tdude_co-9452bcc45958fa18bd91f1e3c4c5db6d" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "lolisafe"
  value   = "traefik.bedrock.tdude.co"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "soarin-ilo_tdude_co" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "soarin-ilo.235"
  value   = "2a10:4741:36:24:29c:2ff:fe9b:abf2"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "status_tdude_co-759cab2fd5747721744d19e9f1b05f53" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "status"
  value   = "traefik.bedrock.tdude.co"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "stone_tdude_co-9998baa886c316c0567b2cfbd3865b9f" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "stone"
  value   = "158.69.211.121"
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "tdude_co-1661589aaef2dd9259f07d22951c6f35" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "tdude.co"
  value   = "158.69.211.121"
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "www_tdude_co-87e4f41d905d3b6116f38c416dbbd036" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "www"
  value   = "158.69.211.121"
  type    = "A"
  ttl     = 1
  proxied = false
}
resource "cloudflare_record" "_235-gw_235_tdude_co-f7e5fb3735adc924b4e04b0887a65270" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "235-gw.235"
  value   = "2a10:4741:33:1::2"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "_235_tdude_co-b73dce106a455e5ba493ea51f4ac61b6" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "235"
  value   = "2a10:4741:33:1::2"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "_305-1700-gw_305-1700_tdude_co-55c277d95f2b6c7d6d077a3732742e5e" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "305-1700-gw.305-1700"
  value   = "2a10:4741:33:2::2"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "_305-1700_tdude_co-1bdb980fa9e481c74caf8dd3d3030848" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "305-1700"
  value   = "2a10:4741:33:2::2"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "auth_bedrock_tdude_co-e600072af53ca2808f9a70af1259c10b" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "auth.bedrock"
  value   = "traefik.bedrock.tdude.co"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "stormfeather_235_tdude_co_AAAA" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "stormfeather.235"
  value   = "2a10:4741:36:29:202:c9ff:fe9d:c36a"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "sassaflash_235_tdude_co_AAAA" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "sassaflash.235"
  value   = "2a10:4741:36:29:26be:5ff:fe84:d8b0"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "fleetfoot_235_tdude_co-0682464601437aabb4960f25ecb9b1b4" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "fleetfoot.235"
  value   = "2a10:4741:36:29:7c53:9eff:fe70:7df3"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "grafana_bedrock_tdude_co-cff47ef8a89f14bf6dd3ff10b1d68de1" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "grafana.bedrock"
  value   = "traefik.bedrock.tdude.co"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "inspiron530_260_tdude_co-54898725081cdac5098dffb842814fed" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "inspiron530.260"
  value   = "2607:fa48:6eca:a751:ac0:5b71:3ca0:a163"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "monitor_bedrock_tdude_co-85e00f4ca90f98269d7dd6ef30aaeaca" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "monitor.bedrock"
  value   = "traefik.bedrock.tdude.co"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "stone_tdude_co-8e4a8fb614f12b4a8e2bada62a41396b" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "stone"
  value   = "2607:5300:201:3100::7e8c"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "tdude_co-c65f52f200afd91efed739ab5122adf1" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "tdude.co"
  value   = "2607:5300:201:3100::7e8c"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "spitfire_235_tdude_co-AAAA" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "spitfire.235"
  value   = "2a10:4741:36:29:225:90ff:fe86:9cd6"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "spitfire-bmc_235_tdude_co-AAAA" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "spitfire-bmc.235"
  value   = "2a10:4741:36:24:0225:90ff:fe86:fb4c"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "spitfire_storage_235_tdude_co-AAAA" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "spitfire.storage.235"
  value   = "2a10:4741:36:28:e61d:2dff:fe90:80fe"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "firestreak_235_tdude_co-AAAA" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "firestreak.235"
  value   = "2a10:4741:36:29:225:90ff:fe86:9cd2"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "firestreak-bmc_235_tdude_co-AAAA" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "firestreak-bmc.235"
  value   = "2a10:4741:36:24:0225:90ff:fe86:fb4a"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "firestreak_storage_235_tdude_co-AAAA" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "firestreak.storage.235"
  value   = "2607:fa48:6ed8:8a55:f652:14ff:fea2:89ec"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "www_tdude_co-110da07cb7c67be474675d1b2b7a6af6" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "www"
  value   = "2607:5300:201:3100::7e8c"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "tdude_co-7dec68f62be8c7fd1afc990a62611dfd" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "tdude.co"
  data {
    flags = 0
    tag   = "iodef"
    value = "mailto:tristan@tdude.co"
  }
  type    = "CAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "tdude_co-62ff3f5817cd2f7a41790bb0ad4d24c1" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "tdude.co"
  data {
    flags = 0
    tag   = "issue"
    value = "letsencrypt.org"
  }
  type    = "CAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "bunker_tdude_co-81c215b5dfa5022bba6f7d87199d1986" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "bunker"
  value   = "guillaumemercier.com"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "fleetfoot_tdude_co-7f7bb593122417df90d1af665407b0ce" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "fleetfoot"
  value   = "235.tdude.co"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "imap_tdude_co-4f31c8d9fb1291a080af75741456cae6" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "imap"
  value   = "tdude.co"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "legacy_tdude_co-39a6af77e769f2e69db5387e1398af2d" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "legacy"
  value   = "stone.tdude.co"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "STAR_mc_auth_tdude_co-5ee27ab64a29423afad6c2f70ef9d614" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "*.mc.auth"
  value   = "235.tdude.co"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "STAR_mcdev_auth_tdude_co-d8e71bc4d0eb37fe5e3a60d19df768e6" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "*.mcdev.auth"
  value   = "305-1700.tdude.co"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "STAR_localhost4_tdude_co-CNAME" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "*.localhost4"
  value   = "localhost4.tdude.co"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "localhost4_tdude_co-A" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "localhost4"
  value   = "127.0.0.1"
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "smtp_tdude_co-8831319c8ac7c5fe14007b106ec64abf" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "smtp"
  value   = "tdude.co"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "soarin_tdude_co-68d3dc90cd44a475929631c7a74f3e3f" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "soarin.235"
  value   = "2a10:4741:36:29:26be:5ff:fe84:f750"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "tdude_co-7a0081a70287ca28d715fca5b75d14b8" {
  zone_id  = cloudflare_zone.tdude_co.id
  name     = "tdude.co"
  value    = "stone.tdude.co"
  type     = "MX"
  priority = "10"
  ttl      = 1
  proxied  = false
}

resource "cloudflare_record" "stone_tdude_co-2179ebef8a058bba0e28d359c8bea8ed" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "stone"
  data {
    algorithm   = 1
    fingerprint = "EE92EB97F26A9CE1B9C4452F429708B5BEFB1EC3"
    type        = 1
  }
  type    = "SSHFP"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "stone_tdude_co-f7eab1022b4fa2ea46c02d454ec60fd9" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "stone"
  data {
    algorithm   = 1
    fingerprint = "5A905B9C8F5E8A9FB8B03B50CC33480A5FE3BB4865E5D7A724F9FCE7BFD2F7F3"
    type        = 2
  }
  type    = "SSHFP"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "stone_tdude_co-d8d0c4a3f9343987ed015d04c9fde84c" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "stone"
  data {
    algorithm   = 3
    fingerprint = "78AEFE1AA58613C12494D80A0C11E216CF685F0B"
    type        = 1
  }
  type    = "SSHFP"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "stone_tdude_co-26756bbbe9a8d030ff95e98b8a094c54" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "stone"
  data {
    algorithm   = 3
    fingerprint = "7ECB56E084127FDDCA1C7907FF5F6F2060540A5012B35D745FE5DDA96D494773"
    type        = 2
  }
  type    = "SSHFP"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "stone_tdude_co-54891e7099e62a0309807495d5c2b331" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "stone"
  data {
    algorithm   = 4
    fingerprint = "9F8843F8F6525551397ED50C114F6E55964CA466"
    type        = 1
  }
  type    = "SSHFP"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "stone_tdude_co-7355b626ba8aa8028c6871fa64f5dae9" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "stone"
  data {
    algorithm   = 4
    fingerprint = "C2EBF70430B5CAB202C80D390A80C2A53859898055D81094B7ED3E386884926B"
    type        = 2
  }
  type    = "SSHFP"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "_201608__domainkey_tdude_co-e93f862066906dc624a65310026c16cc" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "201608._domainkey"
  value   = "v=DKIM1; k=rsa; s=email; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAyxeUzz+l0IQZG0Nn7CJgroSmazG4p0azC1nyydwkZ9nKQ0H5en9dNClX8Epw6onyn8sqYpQQoBhW/TgMBjvmFZp9zOZxddCxgR3vAckeTUtiLR7F4hI339xyXhQgnVsQNCglTGaz27ca/WXVByp13A5cqXnu1V7r+9xVlteXrs2OdCehtDRnRfWBZR13yifeKTLUWJ444T5K4wjqRf5oApJKTcLi6S+fVK3eDJ2hm0Yvre1vMrJhz+zoLvUNyujxZAlkx+Me/bFxqTu3dFSUo8ySaWaNhBPu1CePQ4Jc+1AoRAUOz2sx5SyT12s/0dBa3gJnP2SKCzHZTjERNfiPHwIDAQAB"
  type    = "TXT"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "dkim_tdude_mail" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "mail._domainkey"
  value   = "v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAtqUHIM6dE7luX9HkKb9jZb6rxX2BSRYZMFEnf3gLtKRn4t20Y08TttIOAyiymHcGTwG6osChbnvRMZKff+NjlI7MfVVH0+hRgc0mJKWXjzIRkTUXOr9aTDmujwnYCfpJ/mCcckqNjBI4HaDBSo1i6glWinmm8U8zKORmp3SCMYttc0pTxs0Z7Lm9nJBFGxcqZEzANRHYkMLbfLM9+Khol1VnzFZZfSGag+bHRvNyhIJ+AXNLvdHoObEAa2RHm+yQUHmL+uH/La60kUhVSgDenlPivbjX/XXxqMudFJ1FDHI/JHtqzhYGFYhHGjDDMvh4Jg+MI1IxBqEPYuedt/v2+QIDAQAB"
  type    = "TXT"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "_dmarc_tdude_co-4de172137b73fb7c61bcfa72f2aad7db" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "_dmarc"
  value   = "v=DMARC1; p=none; fo=d; adkim=s; aspf=r"
  type    = "TXT"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "tdude_co-1c2a6f94ff74d3f858a9a0f0b7e5f45f" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "tdude.co"
  value   = "google-site-verification=-ng_xi5Q6NBrXbeKYkm2nf3qC622567dqciT7BYKS8Y"
  type    = "TXT"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "bedrock_tdude_co-A" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "bedrock"
  value   = "135.181.141.143"
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "bedrock_tdude_co-AAAA" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "bedrock"
  value   = "2a01:4f9:3a:15b0::2"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "traefik_bedrock_tdude_co-A" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "traefik.bedrock.tdude.co"
  value   = "135.181.141.143"
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "traefik_bedrock_tdude_co-AAAA" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "traefik.bedrock.tdude.co"
  value   = "2a01:4f9:3a:15b0:8::2"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "photofinish_305-1700" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "photofinish.305-1700.tdude.co"
#  value   = "2001:470:b08b:51::a"
  value   = "172.17.51.16"
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "ovirt_305-1700" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "ovirt.305-1700.tdude.co"
#  value   = "2001:470:b08b:51::b"
  value   = "172.17.51.17"
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "traefik_305-1700" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "traefik.305-1700.tdude.co"
  value   = "2a10:4741:37:d::2"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "cloud_305-1700" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "cloud.305-1700"
  value   = "traefik.305-1700.tdude.co"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "portainer_305-1700" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "portainer.305-1700"
  value   = "traefik.305-1700.tdude.co"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "ha_305-1700" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "ha.305-1700"
  value   = "traefik.305-1700.tdude.co"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "zwavejs_305-1700" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "zwavejs.305-1700"
  value   = "traefik.305-1700.tdude.co"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "soyberry" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "soyberry.305-1700"
  value   = "2a10:4741:37:51:dea6:32ff:fe99:a276"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "borgbackup_235" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "borgbackup.235"
  value   = "2a10:4741:36:29:25:90ff:fe69:277d"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "fogserver_305-1700_AAAA" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "fogserver.305-1700.tdude.co"
  value   = "172.16.2.4"
  type    = "A"
  ttl     = 1
  proxied = false
}
