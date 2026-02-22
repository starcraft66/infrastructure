{ config, lib, ... }:

with lib;
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
      type = types.attrsOf types.str;
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
      type = types.listOf types.str;
      description = "List of etcd endpoint URLs (https://host:2379)";
    };

    interface = mkOption {
      type = types.str;
      description = "Network interface for Keepalived VRRP and node IP resolution";
    };

    lbIpv4Address = mkOption {
      type = types.str;
      description = "Keepalived VIP IPv4 for PostgreSQL";
    };

    lbIpv6Address = mkOption {
      type = types.str;
      description = "Keepalived VIP IPv6 for PostgreSQL";
    };

    pki = {
      vaultURL = mkOption {
        type = types.str;
        description = "The URL of the vault server for vault-agent";
      };
      vaultSNI = mkOption {
        type = types.str;
        description = "The SNI host to use to connect to the vault server";
      };
      clusterName = mkOption {
        type = types.str;
        description = "The cluster name used in Vault PKI paths";
      };
    };
  };
}
