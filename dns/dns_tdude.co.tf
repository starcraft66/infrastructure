resource "cloudflare_zone" "tdude_co" {
  zone = "tdude.co"
  # id = "c802e5f57a27af705373d5d3570649f0"
}

resource "cloudflare_record" "_235-gw_235_tdude_co-fba035a4d6c709a48f4cc574a50a8917" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "235-gw.235"
  value   = "107.171.232.27"
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "_235_tdude_co-e8f98ca862faaf9db482c45216a1493b" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "235"
  value   = "107.171.232.27"
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "_305-1700-gw_305-1700_tdude_co-44620ea4a39eb01253f28d303a47290f" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "305-1700-gw.305-1700"
  value   = "107.190.40.244"
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "_305-1700_tdude_co-f9bbec63e0fc407399c793115267c239" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "305-1700"
  value   = "107.190.40.244"
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "auth_sapling_tdude_co-57da56529c276855860f2257f324237d" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "auth.sapling"
  value   = "158.69.118.62"
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "awx_tdude_co-d85b58b3ced4a68d449257c33f859d7c" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "awx"
  value   = "107.171.232.27"
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "bitwarden_tdude_co-aec56332e0d57d10096bf51ce55d55d0" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "bitwarden"
  value   = "107.171.232.27"
  type    = "A"
  ttl     = 120
  proxied = false
}

resource "cloudflare_record" "cadvisor_sapling_tdude_co-db5de91b27b5078488d6d32f51e08fdc" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "cadvisor.sapling"
  value   = "158.69.118.62"
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "ci_tdude_co-cfa5653b0c15ee01ec19db0fec6edec9" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "ci"
  value   = "158.69.211.121"
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "deluge_sapling_tdude_co-04b501ad44cbce861c65e5b49d740c83" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "deluge.sapling"
  value   = "158.69.118.62"
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "firefly_tdude_co-7d1db62ff46a9a3c00f2c9e11e8471e4" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "firefly"
  value   = "107.171.232.27"
  type    = "A"
  ttl     = 120
  proxied = false
}

resource "cloudflare_record" "fleetfoot-ilo_tdude_co-5e2bf28301bb27e8562684c4c89cd739" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "fleetfoot-ilo"
  value   = "172.16.24.21"
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "git_tdude_co-15e863f9cc46997d6dff0c6f6d9d6b8b" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "git"
  value   = "158.69.118.62"
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "grafana_sapling_tdude_co-c65600b97a15663df0fed97aa6f5fd33" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "grafana.sapling"
  value   = "158.69.118.62"
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "grafana_tdude_co-d417ff1811833b234d8504ba4c97fb34" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "grafana"
  value   = "107.171.232.27"
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "guacamole-int_tdude_co-b8f3aad03ad9129c8680b0a7c699674a" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "guacamole-int"
  value   = "192.168.112.144"
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "jackett_sapling_tdude_co-c6f82e3b3832feebe4e837e51242c9d0" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "jackett.sapling"
  value   = "158.69.118.62"
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "kibana_sapling_tdude_co-da4c426ea1178df2b3c7e21851fe2f95" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "kibana.sapling"
  value   = "158.69.118.62"
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "lolisafe_tdude_co-9452bcc45958fa18bd91f1e3c4c5db6d" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "lolisafe"
  value   = "158.69.118.62"
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "monitor_sapling_tdude_co-a035e125c99409a3115de8eb4b139b84" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "monitor.sapling"
  value   = "158.69.118.62"
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "networkvm_235_tdude_co-957c171b0222f5bfc6773c8970798912" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "networkvm.235"
  value   = "107.171.232.27"
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "networkvm_tdude_co-f4a2896bc8f68bfd8898c28b93c1caba" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "networkvm"
  value   = "192.168.112.148"
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "oldintranet_tdude_co-2f4d564bdc7271e15cf2fa515993d825" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "oldintranet"
  value   = "107.171.232.27"
  type    = "A"
  ttl     = 120
  proxied = false
}

resource "cloudflare_record" "plex_sapling_tdude_co-22776aada2f4b80110b76a14a879fc04" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "plex.sapling"
  value   = "158.69.118.62"
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "tautulli_sapling_tdude_co-A" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "tautulli.sapling"
  value   = "158.69.118.62"
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "pomf-files_tdude_co-fb3af32c70d3bd5cde57cb9afa4f385b" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "pomf-files"
  value   = "107.171.232.27"
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "pomf_tdude_co-86e592db9dfdb1bf1404a4c6dc21f181" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "pomf"
  value   = "107.171.232.27"
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "prometheus_sapling_tdude_co-f0e3d634958f2062196d09cb9240fc5f" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "prometheus.sapling"
  value   = "158.69.118.62"
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "radarr_sapling_tdude_co-9d3d4bd2a53e348deca2f819a64c0b53" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "radarr.sapling"
  value   = "158.69.118.62"
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "sapling_tdude_co-da93011652bf0f8c3353d7ef3de78562" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "sapling"
  value   = "158.69.118.62"
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "soarin-ilo_tdude_co-5bcadae620bb380e30c88ce658fd8d53" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "soarin-ilo"
  value   = "172.16.24.20"
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "sonarr_sapling_tdude_co-15e7f8ac512941d0575a1ff6cb271d6b" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "sonarr.sapling"
  value   = "158.69.118.62"
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "status_tdude_co-759cab2fd5747721744d19e9f1b05f53" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "status"
  value   = "158.69.118.62"
  type    = "A"
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

resource "cloudflare_record" "trixie-int_tdude_co-9ffefcf0c68ca311bb94be154f2cf82f" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "trixie-int"
  value   = "172.16.29.20"
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "trixie_tdude_co-b1d7df06e4d1e568e2e7af44b6b981af" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "trixie"
  value   = "107.171.232.27"
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

resource "cloudflare_record" "xoa_tdude_co-1d4903868174411a0e2c98a1cd21d35e" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "xoa"
  value   = "172.16.29.61"
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "zabbix_tdude_co-ced531cda883f1fa2e768ebc2882d228" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "zabbix"
  value   = "158.69.211.121"
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "_235-gw_235_tdude_co-f7e5fb3735adc924b4e04b0887a65270" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "235-gw.235"
  value   = "2607:fa48:6c16:81b0::1"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "_235_tdude_co-b73dce106a455e5ba493ea51f4ac61b6" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "235"
  value   = "2607:fa48:6c16:81b0::1"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "_305-1700-gw_305-1700_tdude_co-55c277d95f2b6c7d6d077a3732742e5e" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "305-1700-gw.305-1700"
  value   = "2001:470:1c:274::2"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "_305-1700_tdude_co-1bdb980fa9e481c74caf8dd3d3030848" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "305-1700"
  value   = "2001:470:1c:274::2"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "auth_sapling_tdude_co-e600072af53ca2808f9a70af1259c10b" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "auth.sapling"
  value   = "2607:5300:60:873e:8::2"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "awx_tdude_co-55633b0b6742bfaaa68b5cdbb79fb7ce" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "awx"
  value   = "2607:fa48:6c16:81b1:1::10"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "blaze_tdude_co-424332459ad22e0173b54f3f1e25e5c5" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "blaze"
  value   = "2607:fa48:6c16:81b1:226:9eff:fe58:ec9a"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "cadvisor_sapling_tdude_co-6c35129ca6c1c87cf78e3c676aabcd41" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "cadvisor.sapling"
  value   = "2607:5300:60:873e:8::2"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "ci_tdude_co-ca4679c66c673dfa1071f30263fa966c" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "ci"
  value   = "2607:5300:201:3100::7e8c"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "deluge_sapling_tdude_co-aabb292b5c3bfb2a80892a63bab6b06b" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "deluge.sapling"
  value   = "2607:5300:60:873e:8::2"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "docker_235_tdude_co-dd0c7342973683671b57e1a636fb9c9f" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "docker.235"
  value   = "2607:fa48:6c16:81b1:20bb:57ff:fe41:3dd1"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "docker-at_235_tdude_co-ed861a7e0897f566ca77646e7f4cfe8d" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "docker-at.235"
  value   = "2607:fa48:6c16:81b1:ac66:5dff:fe8d:c2e6"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "firefly_tdude_co-feeb8b36a9941c156e27365251a2c830" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "firefly"
  value   = "2607:fa48:6c16:81b1:1::13"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "fleetfoot_235_tdude_co-0682464601437aabb4960f25ecb9b1b4" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "fleetfoot.235"
  value   = "2607:fa48:6c16:81b1:29c:2ff:fea5:346a"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "git_tdude_co-9cf4851ffe020afbb5e820e79902c356" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "git"
  value   = "2607:5300:60:873e::3"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "grafana_sapling_tdude_co-cff47ef8a89f14bf6dd3ff10b1d68de1" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "grafana.sapling"
  value   = "2607:5300:60:873e:8::2"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "grafana_tdude_co-78501fdae4a693fa3dc129b06c9dd725" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "grafana"
  value   = "2607:fa48:6c16:81b1:1::6"
  type    = "AAAA"
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

resource "cloudflare_record" "jackett_sapling_tdude_co-0f0b16e25fdf8f89db870301b0870292" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "jackett.sapling"
  value   = "2607:5300:60:873e:8::2"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "k8s-node1_235_tdude_co-0deb1141f0c1a891bab69faf299bd30f" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "k8s-node1.235"
  value   = "2607:fa48:6c16:81b4::100:1"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "k8s-node2_235_tdude_co-21d2a88574d06dc5a62f7147e84267e7" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "k8s-node2.235"
  value   = "2607:fa48:6c16:81b4::100:2"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "k8s-node3_235_tdude_co-55c85b67756783584549335368e6c646" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "k8s-node3.235"
  value   = "2607:fa48:6c16:81b4::100:3"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "kibana_sapling_tdude_co-97b08930e2931a80c84863437faf9606" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "kibana.sapling"
  value   = "2607:5300:60:873e:8::2"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "lolisafe_tdude_co-13ced20edcdab4f702f5fb21e0f1c784" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "lolisafe"
  value   = "2607:5300:60:873e:8::2"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "minecraft_235_tdude_co-ab96afc3a095ae6e1a78d14071fff425" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "minecraft.235"
  value   = "2607:fa48:6c16:81b1:8c8f:e7ff:fe25:271a"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "monitor_sapling_tdude_co-85e00f4ca90f98269d7dd6ef30aaeaca" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "monitor.sapling"
  value   = "2607:5300:60:873e:8::2"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "networkvm_235_tdude_co-ef29aa214ac2068bba95c15259c03a3a" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "networkvm.235"
  value   = "2607:fa48:6c16:81b1:3071:29ff:fe2d:cfea"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "oldintranet_tdude_co-7d73081223ecdfcc503925a097b40a2f" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "oldintranet"
  value   = "2607:fa48:6c16:81b1:1::12"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "plex_sapling_tdude_co-cc8e48931282ecb8338a0a274380c960" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "plex.sapling"
  value   = "2607:5300:60:873e:8::2"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "tautulli_sapling_tdude_co-AAAA" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "tautulli.sapling"
  value   = "2607:5300:60:873e:8::2"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "pomf-files_tdude_co-b45b58aad36c7c11b38bb58f121df274" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "pomf-files"
  value   = "2607:fa48:6c16:81b1:1::7"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "pomf_tdude_co-90fff8545cb09632324adcc17f60b05d" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "pomf"
  value   = "2607:fa48:6c16:81b1:1::8"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "prometheus_sapling_tdude_co-a844e88f822d5a14109aa0b0ab4db9ee" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "prometheus.sapling"
  value   = "2607:5300:60:873e:8::2"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "radarr_sapling_tdude_co-834ac9f4bd31ce39388a6d3be8e0b968" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "radarr.sapling"
  value   = "2607:5300:60:873e:8::2"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "sapling_tdude_co-d5e05c75c5dc40ed4ff6348af0f51d40" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "sapling"
  value   = "2607:5300:60:873e::"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "sonarr_sapling_tdude_co-fe38617f9a745a5b2c48bffc2c7b5746" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "sonarr.sapling"
  value   = "2607:5300:60:873e:8::2"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "status_tdude_co-53417a618617866899b88237f0a2d1b5" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "status"
  value   = "2607:5300:60:873e:8::2"
  type    = "AAAA"
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

resource "cloudflare_record" "thorn_tdude_co-cfca003a07d87facd66ae71facc3b367" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "thorn"
  value   = "2607:fa48:6c16:81b1:226:9eff:fe58:80da"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "trixie_tdude_co-ed6755c69142841c707ce4793f6a0a56" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "trixie"
  value   = "2607:fa48:6c16:81b1:4b28:2b6f:fdc4:cf09"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "unifi_tdude_co-36df8291a214ceb05d7dd011cd08dff1" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "unifi"
  value   = "2607:fa48:6c16:81b1:1::11"
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

resource "cloudflare_record" "zabbix_tdude_co-fc2ef9d9a1fafbe74184249cba03594a" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "zabbix"
  value   = "2607:5300:201:3100::7e8c"
  type    = "AAAA"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "tdude_co-7dec68f62be8c7fd1afc990a62611dfd" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "tdude.co"
  data    = {
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
  data    = {
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

resource "cloudflare_record" "guacamole_tdude_co-b24ddb2ecbf598a56175342307651836" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "guacamole"
  value   = "235.tdude.co"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "imap_tdude_co-4f31c8d9fb1291a080af75741456cae6" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "imap"
  value   = "235.tdude.co"
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
  value   = "sapling.tdude.co"
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

resource "cloudflare_record" "mc_tdude_co-11d119e1e74e65280ab03cd99e5dbbbd" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "mc"
  value   = "235.tdude.co"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "prod_at-int_tdude_co-813b71f154e4f52996fefb67243818eb" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "prod.at-int"
  value   = "235.tdude.co"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "registry_at-int_tdude_co-3cb03bf67ce479a2a77e8c6843232a90" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "registry.at-int"
  value   = "235.tdude.co"
  type    = "CNAME"
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
  name    = "soarin"
  value   = "235.tdude.co"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "sso-auth_tdude_co-efd49832fde842524121fec53b373552" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "sso-auth"
  value   = "235.tdude.co"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "STAR_sso_tdude_co-d7b0276630065711cdba7d0deb83856d" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "*.sso"
  value   = "235.tdude.co"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "staging_at-int_tdude_co-bc0fe6f01ff94c5a86e001bb82abd3a0" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "staging.at-int"
  value   = "235.tdude.co"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "unifi_305-1700_tdude_co-70b2c52d0250907a782363750691bb24" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "unifi.305-1700"
  value   = "unifi.tdude.co"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "unms_tdude_co-6366e7b20544a759d83e9d30cb77e84d" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "unms"
  value   = "trixie-int.tdude.co"
  type    = "CNAME"
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

resource "cloudflare_record" "_minecraft__tcp_e2_tdude_co-7b8febea56a7348e5f16b1260b8e7ab3" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "_minecraft._tcp.e2"
  data    = {
    name      = "e2"
    port      = 1883
    priority  = 1
    proto     = "_tcp"
    service   = "_minecraft"
    target    = "235.tdude.co"
    weight    = 1
  }
  type    = "SRV"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "_minecraft__tcp_ftbu_tdude_co-21e77d917ba80064d4cb6289f960a086" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "_minecraft._tcp.ftbu"
  data    = {
    name      = "ftbu"
    port      = 1884
    priority  = 1
    proto     = "_tcp"
    service   = "_minecraft"
    target    = "235.tdude.co"
    weight    = 1
  }
  type    = "SRV"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "_minecraft__tcp_infitech_tdude_co-7ac5516d747aa3e68810034d6716ab95" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "_minecraft._tcp.infitech"
  data    = {
    name      = "infitech"
    port      = 1488
    priority  = 1
    proto     = "_tcp"
    service   = "_minecraft"
    target    = "235.tdude.co"
    weight    = 1
  }
  type    = "SRV"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "_minecraft__tcp_revelation_tdude_co-fe2f6abd7ec4b63464964651cdad867c" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "_minecraft._tcp.revelation"
  data    = {
    name      = "revelation"
    port      = 1882
    priority  = 1
    proto     = "_tcp"
    service   = "_minecraft"
    target    = "235.tdude.co"
    weight    = 1
  }
  type    = "SRV"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "_minecraft__tcp_validation_mc_tdude_co-befcf5b827643943e79c995fe5b87603" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "_minecraft._tcp.cacaffichage"
  data    = {
    name      = "cacaffichage"
    port      = 1885
    priority  = 1
    proto     = "_tcp"
    service   = "_minecraft"
    target    = "235.tdude.co"
    weight    = 1
  }
  type    = "SRV"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "stone_tdude_co-2179ebef8a058bba0e28d359c8bea8ed" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "stone"
  data    = {
    algorithm = 1
    fingerprint = "EE92EB97F26A9CE1B9C4452F429708B5BEFB1EC3"
    type = 1
  }
  type    = "SSHFP"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "stone_tdude_co-f7eab1022b4fa2ea46c02d454ec60fd9" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "stone"
  data    = {
    algorithm = 1
    fingerprint = "5A905B9C8F5E8A9FB8B03B50CC33480A5FE3BB4865E5D7A724F9FCE7BFD2F7F3"
    type = 2
  }
  type    = "SSHFP"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "stone_tdude_co-d8d0c4a3f9343987ed015d04c9fde84c" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "stone"
  data    = {
    algorithm = 3
    fingerprint = "78AEFE1AA58613C12494D80A0C11E216CF685F0B"
    type = 1
  }
  type    = "SSHFP"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "stone_tdude_co-26756bbbe9a8d030ff95e98b8a094c54" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "stone"
  data    = {
    algorithm = 3
    fingerprint = "7ECB56E084127FDDCA1C7907FF5F6F2060540A5012B35D745FE5DDA96D494773"
    type = 2
  }
  type    = "SSHFP"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "stone_tdude_co-54891e7099e62a0309807495d5c2b331" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "stone"
  data    = {
    algorithm = 4
    fingerprint = "9F8843F8F6525551397ED50C114F6E55964CA466"
    type = 1
  }
  type    = "SSHFP"
  ttl     = 1
  proxied = false
}

resource "cloudflare_record" "stone_tdude_co-7355b626ba8aa8028c6871fa64f5dae9" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "stone"
  data    = {
    algorithm = 4
    fingerprint = "C2EBF70430B5CAB202C80D390A80C2A53859898055D81094B7ED3E386884926B"
    type = 2
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

resource "cloudflare_record" "_acme-challenge_auth_sapling_tdude_co-2d8345e1a4db15a27b2de23486046751" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "_acme-challenge.auth.sapling"
  value   = "jtQEDpwOfMARrPmzD_A5ipDlZgz4CNbg8Qf3PjrFbP0"
  type    = "TXT"
  ttl     = 120
  proxied = false
}

resource "cloudflare_record" "_acme-challenge_awx_tdude_co-73494463f8947e89216ebaa43cf7ee29" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "_acme-challenge.awx"
  value   = "2ft73x7Jt_X5Sx0uNsH8DK4Ud_8m_7k7oexfmoks-zI"
  type    = "TXT"
  ttl     = 120
  proxied = false
}

resource "cloudflare_record" "_acme-challenge_firefly_tdude_co-742ca7b5f2ae2796f67b6b883e2beb15" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "_acme-challenge.firefly"
  value   = "R2XO9l1ge7wFVKxudyCZRgPcbW8BiI10WCqpQWV_bdE"
  type    = "TXT"
  ttl     = 120
  proxied = false
}

resource "cloudflare_record" "_acme-challenge_grafana_tdude_co-b736c4beaa506d7233fbb39a5c8c56a8" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "_acme-challenge.grafana"
  value   = "NQaeThixSS9zbO4dxeF86GfrodsZeaG0_2skhPXQ6LI"
  type    = "TXT"
  ttl     = 120
  proxied = false
}

resource "cloudflare_record" "_acme-challenge_oldintranet_tdude_co-45728c8f4a78b16b112464cb45fcb5d9" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "_acme-challenge.oldintranet"
  value   = "Iu5zZ2LssAGjW3fAcHnO610GUmE64qBKdQN3DULm5j8"
  type    = "TXT"
  ttl     = 120
  proxied = false
}

resource "cloudflare_record" "_dmarc_tdude_co-4de172137b73fb7c61bcfa72f2aad7db" {
  zone_id = cloudflare_zone.tdude_co.id
  name    = "_dmarc"
  value   = "v=DMARC1; p=none; rua=mailto:tristan@tdude.co; ruf=mailto:tristan@tdude.co; fo=d; adkim=s; aspf=r"
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

