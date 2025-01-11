{ config, name, lib, pkgs, inputs, ... }:
with lib;
let
  cfg = config.services.tdude.kubernetes.worker;
in {
  imports = [ ./coredns.nix ./cilium.nix ./pki.nix ./proxy.nix ./kubelet.nix ];

  options.services.tdude.kubernetes.worker = {
    enable = options.mkEnableOption "Enable the kubernetes control-plane role";
    nvidia.enable = options.mkEnableOption {
      description = "Enable the nvidia container runtime class";
      default = false;
    };
    kube-proxy.enable = options.mkEnableOption {
      description = "Enable the kube-proxy service";
      default = true;
    };
    nodeIps = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "List of IP addresses to publish in the host's Node object as InternalIPs";
    };
    ipSans = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "List of SANs to add to the node's certificate";
    };
    clusterCidrIpv4 = mkOption {
      type = types.str;
      description = "The IPv4 pod CIDR range for the kubernetes cluster";
    };
    clusterCidrIpv6 = mkOption {
      type = types.str;
      description = "The IPv6 pod CIDR range for the kubernetes cluster";
    };
    apiserverAddress = mkOption {
      type = types.str;
      description = "The address of the kubernetes apiserver";
    };
    dnsResolvers = mkOption {
      type = types.listOf types.str;
      description = "List of DNS resolvers to use for pod DNS resolution";
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
  config.services.kubernetes.package = lib.mkOverride 999 inputs.self.packages.${pkgs.stdenv.system}.kubernetes_1_32_0;
}
