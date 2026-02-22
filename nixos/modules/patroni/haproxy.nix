{ config, lib, ... }:

let
  cfg = config.services.tdude.patroni;
  pgBackend =
    hostname:
    "server ${builtins.head (lib.splitString "." hostname)} ${hostname}:${toString cfg.postgresPort} maxconn 100 check port ${toString cfg.patroniPort}";
  backends = map pgBackend (lib.mapAttrsToList (_: hostname: hostname) cfg.clusterMembers);
in
lib.mkIf cfg.enable {
  # Append PostgreSQL frontends/backends to existing HAProxy config
  services.haproxy.config = lib.mkAfter ''

    listen postgres
      mode tcp
      bind ${cfg.lbIpv4Address}:5432
      bind ${cfg.lbIpv6Address}:5432
      option httpchk GET /primary
      http-check expect status 200
      default-server inter 3s fall 3 rise 2 on-marked-down shutdown-sessions
      ${builtins.concatStringsSep "\n  " backends}

    listen postgres-replicas
      mode tcp
      bind ${cfg.lbIpv4Address}:5433
      bind ${cfg.lbIpv6Address}:5433
      option httpchk GET /replica
      http-check expect status 200
      default-server inter 3s fall 3 rise 2 on-marked-down shutdown-sessions
      ${builtins.concatStringsSep "\n  " backends}
  '';
}
