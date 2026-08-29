{ config, lib, pkgs, ... }:

with lib;
let
  netTypes = pkgs.lib.tdude.net.types;
in
{
  imports = [
    ./patroni.nix
    ./pki.nix
    ./haproxy.nix
    ./keepalived.nix
  ];

  options.services.tdude.patroni = {
    enable = mkEnableOption "Enable the Patroni PostgreSQL HA cluster";

    clusterName = mkOption {
      type = types.str;
      description = "Patroni cluster scope name";
      example = "pg-235-1";
    };

    clusterMembers = mkOption {
      type = types.attrsOf netTypes.host;
      description = "Map of node short names to FQDNs";
      example = {
        node1 = "node1.example.com";
        node2 = "node2.example.com";
      };
    };

    postgresPort = mkOption {
      type = types.port;
      default = 5432;
      description = "PostgreSQL listen port";
    };

    patroniPort = mkOption {
      type = types.port;
      default = 8008;
      description = "Patroni REST API port";
    };

    etcdUrls = mkOption {
      type = types.listOf netTypes.url;
      description = "List of etcd endpoint URLs (https://host:2379)";
    };

    environmentFile = mkOption {
      type = types.path;
      description = "Path to environment file containing PATRONI_REPLICATION_PASSWORD, PATRONI_SUPERUSER_PASSWORD, and PATRONI_REWIND_PASSWORD";
    };

    synchronousMode = mkOption {
      type = types.bool;
      default = true;
      description = "Enable synchronous replication. Set to false for single-node clusters.";
    };

    pgHbaNetworks = mkOption {
      type = types.listOf (
        types.submodule {
          options = {
            ipv4 = mkOption {
              type = netTypes.ipv4Cidr;
              description = "IPv4 CIDR range for pg_hba rules (e.g. 172.16.29.0/24)";
            };
            ipv6 = mkOption {
              type = netTypes.ipv6Cidr;
              description = "IPv6 CIDR range for pg_hba rules (e.g. 2a10:4741:36:29::/64)";
            };
          };
        }
      );
      description = "Network CIDR ranges allowed to connect to PostgreSQL";
    };

    interface = mkOption {
      type = netTypes.interfaceName;
      description = "Network interface for Keepalived VRRP and node IP resolution";
    };

    lbIpv4Address = mkOption {
      type = netTypes.ipv4;
      description = "Keepalived VIP IPv4 for PostgreSQL";
    };

    lbIpv6Address = mkOption {
      type = netTypes.ipv6;
      description = "Keepalived VIP IPv6 for PostgreSQL";
    };

    pki = {
      vaultURL = mkOption {
        type = netTypes.url;
        description = "The URL of the vault server for vault-agent";
      };
      vaultSNI = mkOption {
        type = netTypes.host;
        description = "The SNI host to use to connect to the vault server";
      };
      clusterName = mkOption {
        type = types.str;
        description = "The cluster name used in Vault PKI paths";
      };
    };
  };
}
