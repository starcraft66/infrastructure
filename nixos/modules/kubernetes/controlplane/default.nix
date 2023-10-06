{ config, lib, ... }:

with lib;
let
  cfg = config.services.tdude.kubernetes.control-plane;
in {
  imports = [ ./apiserver.nix ./controller-manager.nix ./scheduler.nix ./pki.nix ];
  options.services.tdude.kubernetes.control-plane = {
    enable = mkEnableOption "Enable the kubernetes control-plane role";
    ipSans = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "List of SANs to add to the apiserver certificate";
    };  
    clusterCidrIpv4 = mkOption {
      type = types.str;
      description = "The IPv4 pod CIDR range for the kubernetes cluster";
    };
    clusterCidrIpv6 = mkOption {
      type = types.str;
      description = "The IPv6 pod CIDR range for the kubernetes cluster";
    };
    serviceCidrIpv4 = mkOption {
      type = types.str;
      description = "The IPv4 service CIDR range for the kubernetes cluster";
    };
    serviceCidrIpv6 = mkOption {
      type = types.str;
      description = "The IPv6 service CIDR range for the kubernetes cluster";
    };
  };
  config.services.kubernetes.clusterCidr = lib.concatStringsSep "," [
    cfg.clusterCidrIpv4
    cfg.clusterCidrIpv6
  ];
}