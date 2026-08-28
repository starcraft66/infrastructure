{ config, lib, pkgs, ... }:

with lib;
let
  netTypes = pkgs.lib.tdude.net.types;
in
{
  imports = [ ./pocket-id.nix ];

  options.services.tdude.pocket-id = {
    enable = mkEnableOption "Enable Pocket ID OIDC provider";

    domain = mkOption {
      type = netTypes.domain;
      description = "Public domain for Pocket ID";
      example = "id.tdude.co";
    };

    port = mkOption {
      type = types.port;
      default = 1411;
      description = "Port on which Pocket ID listens";
    };

    environmentFile = mkOption {
      type = types.path;
      description = "Path to environment file containing DB_CONNECTION_STRING, ENCRYPTION_KEY, and other secrets";
    };

    lbIpv4Address = mkOption {
      type = netTypes.ipv4;
      description = "Keepalived VIP IPv4 for Pocket ID";
    };

    lbIpv6Address = mkOption {
      type = netTypes.ipv6;
      description = "Keepalived VIP IPv6 for Pocket ID";
    };

    interface = mkOption {
      type = netTypes.interfaceName;
      description = "Network interface for Keepalived VRRP";
    };
  };
}
