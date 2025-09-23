{ config, lib, pkgs, inputs, ... }:

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
      description = "List of IP SANs to add to the apiserver certificate";
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
    additionalApiserverAltNames = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "Additional SANs to add to the apiserver certificate";
    };
    oidcIssuerUrl = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "The URL of the OIDC issuer used to authenticate non-certificate-based requests to the apiserver";
    };
    oidcClientId = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "The client ID for the OIDC client";
    };
    etcdServerUrls = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "List of etcd server URLs the apiserver should connect to";
    };
    pki = mkOption {
      type = types.submodule {
        options = {
          vaultURL = mkOption {
            type = types.str;
            description = "The URL of the vault server";
          };
          vaultSNI = mkOption {
            type = types.str;
            description = "The SNI host to use to connect to the vault server";
          };
          clusterName = mkOption {
            type = types.str;
            description = "The name of the kubernetes cluster";
          };
        };
      };
    };
  };
  config.services.kubernetes.clusterCidr = lib.concatStringsSep "," [
    cfg.clusterCidrIpv4
    cfg.clusterCidrIpv6
  ];
  config.services.kubernetes.package = lib.mkDefault inputs.self.packages.${pkgs.stdenv.system}.kubernetes_1_34_1;
}
