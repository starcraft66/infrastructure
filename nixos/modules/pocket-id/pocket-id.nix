{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.tdude.pocket-id;
in
lib.mkIf cfg.enable {
  # Use the upstream NixOS pocket-id module with our settings
  services.pocket-id = {
    enable = true;
    environmentFile = cfg.environmentFile;
    settings = {
      APP_URL = "https://${cfg.domain}";
      TRUST_PROXY = true;
      PORT = toString cfg.port;
      ANALYTICS_DISABLED = true;
      # DB_CONNECTION_STRING is set via environmentFile to keep credentials out of the nix store
    };
  };

  # Pocket ID uses a PostgreSQL advisory lock — only one instance runs at a time.
  # Other nodes retry every 2 minutes until they acquire the lock (e.g. after failover).
  systemd.services.pocket-id = {
    serviceConfig.RestartSec = "120";
    startLimitBurst = 0;
  };

  # ACME certificate for the pocket-id domain
  security.acme.certs.pocket-id = {
    group = "haproxy";
    domain = cfg.domain;
    dnsProvider = "cloudflare";
    reloadServices = [ "haproxy" ];
  };

  # HAProxy frontend/backend for Pocket ID (SSL termination + HTTP health checks)
  services.haproxy.config = lib.mkAfter ''

    listen pocket-id
      mode http
      bind ${cfg.lbIpv4Address}:443 ssl crt /var/lib/acme/pocket-id/full.pem
      bind ${cfg.lbIpv6Address}:443 ssl crt /var/lib/acme/pocket-id/full.pem
      option httpchk GET /healthcheck
      http-check expect status 200
      balance roundrobin
      default-server inter 10s fall 3 rise 2
      ${builtins.concatStringsSep "\n  " (
        lib.mapAttrsToList (
          _: hostname:
          "server ${builtins.head (lib.splitString "." hostname)} ${hostname}:${toString cfg.port} check"
        ) config.services.tdude.patroni.clusterMembers
      )}
  '';

  # Keepalived VIP for Pocket ID
  # VRRP IDs 85-86 used by PostgreSQL, use 87-88 for Pocket ID
  services.keepalived.vrrpInstances.pocketid4 = {
    interface = cfg.interface;
    priority = 100;
    virtualRouterId = 87;
    virtualIps = [ { addr = cfg.lbIpv4Address; } ];
  };
  services.keepalived.vrrpInstances.pocketid6 = {
    interface = cfg.interface;
    priority = 100;
    virtualRouterId = 88;
    virtualIps = [ { addr = cfg.lbIpv6Address; } ];
  };
}
