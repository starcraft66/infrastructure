{ config, lib, ... }:

with lib;
{
  imports = [ ./pocket-id.nix ];

  options.services.tdude.pocket-id = {
    enable = mkEnableOption "Enable Pocket ID OIDC provider";

    domain = mkOption {
      type = types.str;
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
      type = types.str;
      description = "Keepalived VIP IPv4 for Pocket ID";
    };

    lbIpv6Address = mkOption {
      type = types.str;
      description = "Keepalived VIP IPv6 for Pocket ID";
    };

    interface = mkOption {
      type = types.str;
      description = "Network interface for Keepalived VRRP";
    };
  };
}
