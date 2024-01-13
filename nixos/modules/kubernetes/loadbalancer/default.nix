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
    k8sIpv4Address = mkOption {
      type = types.str;
      description = "The IPv4 address to advertise the kubernetes apiserver on";
    };
    k8sIpv6Address = mkOption {
      type = types.str;
      description = "The IPv6 address to advertise the kubernetes apiserver on";
    };
    vaultIpv4Address = mkOption {
      type = types.str;
      description = "The IPv4 address to advertise the kubernetes apiserver on";
    };
    vaultIpv6Address = mkOption {
      type = types.str;
      description = "The IPv6 address to advertise the kubernetes apiserver on";
    };
  };
}


