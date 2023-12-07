{ config, name, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.tdude.kubernetes.worker;
  k8sversions = (import ../../../pkgs/kubernetes/default.nix {inherit pkgs;}).mkKubernetesPackages;
in {
  imports = [ ./coredns.nix ./cilium.nix ./pki.nix ./proxy.nix ./kubelet.nix ];

  options.services.tdude.kubernetes.worker = {
    enable = options.mkEnableOption "Enable the kubernetes control-plane role";
    kube-proxy.enable = options.mkEnableOption {
      description = "Enable the kube-proxy service";
      default = true;
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
  };

  config.services.kubernetes.clusterCidr = lib.concatStringsSep "," [
    cfg.clusterCidrIpv4
    cfg.clusterCidrIpv6
  ];
  config.services.kubernetes.package = lib.mkOverride 999 k8sversions.kubernetes_1_28_4;
}
