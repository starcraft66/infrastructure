{ config, name, lib, pkgs, inputs, ... }:
with lib;
let
  cfg = config.services.tdude.kubernetes.worker;
  netTypes = pkgs.lib.tdude.net.types;
in
{
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
      type = types.listOf netTypes.ip;
      default = [ ];
      description = "List of IP addresses to publish in the host's Node object as InternalIPs";
    };
    ipSans = mkOption {
      type = types.listOf netTypes.ip;
      default = [ ];
      description = "List of SANs to add to the node's certificate";
    };
    clusterCidrIpv4 = mkOption {
      type = netTypes.ipv4Cidr;
      description = "The IPv4 pod CIDR range for the kubernetes cluster";
    };
    clusterCidrIpv6 = mkOption {
      type = netTypes.ipv6Cidr;
      description = "The IPv6 pod CIDR range for the kubernetes cluster";
    };
    apiserverAddress = mkOption {
      type = netTypes.url;
      description = "The address of the kubernetes apiserver";
    };
    dnsResolvers = mkOption {
      type = types.listOf netTypes.ip;
      description = "List of DNS resolvers to use for pod DNS resolution";
    };
    pki = mkOption {
      type = types.submodule {
        options = {
          vaultURL = mkOption {
            type = netTypes.url;
            description = "The URL of the vault server";
          };
          vaultSNI = mkOption {
            type = netTypes.host;
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
  config.services.kubernetes.package = lib.mkOverride 999 inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.kubernetes_1_37_0;
}
