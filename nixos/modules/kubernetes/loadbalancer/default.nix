{ lib, ... }:
with lib;
let
  cfg = config.services.tdude.kubernetes.loadbalancer;
in {
  imports = [ ./keepalived.nix ./haproxy.nix ];

  options.services.tdude.kubernetes.loadbalancer = {
    enable = options.mkEnableOption "Enable the kubernetes apiserver loadbalancer";
    interface = mkOption {
      type = types.str;
      description = "The interface to advertise the kubernetes apiserver on";
    };
    ipv4Address = mkOption {
      type = types.str;
      description = "The address to advertise the kubernetes apiserver on";
    };
    ipv6Address = mkOption {
      type = types.str;
      description = "The address to advertise the kubernetes apiserver on";
    };
  };
}


