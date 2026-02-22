{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.tdude.patroni;
  fqdn = "${config.networking.hostName}.${config.networking.domain}";
  nodeIpv4 = (builtins.elemAt config.networking.interfaces.${cfg.interface}.ipv4.addresses 0).address;
  nodeIpv6 = (builtins.elemAt config.networking.interfaces.${cfg.interface}.ipv6.addresses 0).address;
  otherMemberFqdns = lib.mapAttrsToList (_: fqdn: fqdn) (
    lib.filterAttrs (name: _: name != config.networking.hostName) cfg.clusterMembers
  );

  # Parse etcd hosts from URLs: "https://host:2379" -> "host:2379"
  etcdHosts = map (url: lib.removePrefix "https://" url) cfg.etcdUrls;
in
lib.mkIf cfg.enable {
  services.patroni = {
    enable = true;
    postgresqlPackage = pkgs.postgresql_16;

    scope = cfg.clusterName;
    name = config.networking.hostName;
    # nodeIp is used by upstream for listen/connect_address defaults; we override those below
    nodeIp = nodeIpv4;
    otherNodesIps = otherMemberFqdns;
    softwareWatchdog = false;

    settings = {
      bootstrap = {
        dcs = {
          ttl = 30;
          loop_wait = 10;
          retry_timeout = 10;
          maximum_lag_on_failover = 1048576;
          synchronous_mode = true;
        };
        initdb = [
          { encoding = "UTF8"; }
          "data-checksums"
        ];
      };

      # Override upstream restapi to listen dual-stack and advertise FQDN
      # [::] on Linux with net.ipv6.bindv6only=0 (default) accepts both IPv4 and IPv6
      restapi = {
        listen = lib.mkForce "[::]:${toString cfg.patroniPort}";
        connect_address = lib.mkForce "${fqdn}:${toString cfg.patroniPort}";
      };

      postgresql = {
        use_pg_rewind = true;
        use_slots = true;
        # Listen on node-specific addresses only (not *, which would conflict with HAProxy on the VIP)
        listen = lib.mkForce "${nodeIpv4},${nodeIpv6},127.0.0.1,::1:${toString cfg.postgresPort}";
        # Advertise FQDN so replication works over both IPv4 and IPv6
        connect_address = lib.mkForce "${fqdn}:${toString cfg.postgresPort}";
        authentication = {
          replication.username = "replicator";
          superuser.username = "postgres";
          rewind.username = "rewind";
        };
        parameters = {
          wal_level = "replica";
          hot_standby = "on";
          hot_standby_feedback = "on";
          max_wal_senders = 5;
          max_replication_slots = 5;
          wal_keep_size = "128MB";
        };
        pg_hba = [
          "local all all trust"
          # IPv4
          "host replication replicator 172.16.29.0/24 md5"
          "host replication replicator 127.0.0.1/32 md5"
          "host all all 172.16.29.0/24 scram-sha-256"
          "host all all 127.0.0.1/32 scram-sha-256"
          # IPv6
          "host replication replicator 2a10:4741:36:29::/64 md5"
          "host replication replicator ::1/128 md5"
          "host all all 2a10:4741:36:29::/64 scram-sha-256"
          "host all all ::1/128 scram-sha-256"
        ];
      };

      etcd3 = {
        hosts = lib.concatStringsSep "," etcdHosts;
        protocol = "https";
        cacert = "/var/lib/secrets/patroni/etcd-ca.pem";
        cert = "/var/lib/secrets/patroni/client.pem";
        key = "/var/lib/secrets/patroni/client-key.pem";
      };

      watchdog = {
        mode = "off";
      };

      failsafe_mode = true;
    };

    environmentFiles = {
      PATRONI_REPLICATION_PASSWORD = "/var/lib/secrets/patroni/replication-password";
      PATRONI_SUPERUSER_PASSWORD = "/var/lib/secrets/patroni/superuser-password";
      PATRONI_REWIND_PASSWORD = "/var/lib/secrets/patroni/rewind-password";
    };
  };

  # Ensure /run/postgresql exists for PostgreSQL's Unix socket and lock files
  systemd.tmpfiles.rules = [
    "d /run/postgresql 0755 patroni patroni -"
  ];

  # Patroni must start after vault-agent renders the etcd client certs
  systemd.services.patroni = {
    after = [ "vault-agent-patroni.service" ];
    wants = [ "vault-agent-patroni.service" ];
  };
}
