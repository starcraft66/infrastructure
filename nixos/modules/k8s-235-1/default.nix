{ config, inputs, lib, pkgs, ... }:

let
  cfg = config.services.tdude.k8s-235-1;
  profile = inputs.self.lib.kubernetesClusters."k8s-235-1";
  mkKubernetesClusterConfig = import ../../lib/mk-kubernetes-cluster-config.nix { inherit lib; };
in
{
  options.services.tdude.k8s-235-1 = {
    enable = lib.mkEnableOption "Enable the k8s-235-1 node role";
    primaryNetworkInterface = lib.mkOption {
      type = pkgs.lib.tdude.net.types.interfaceName;
      description = "The primary network interface for the node";
    };
    slaacAddress = lib.mkOption {
      type = pkgs.lib.tdude.net.types.ipv6;
      description = "The SLAAC address for the node";
    };
  };

  config = lib.mkIf cfg.enable (
    mkKubernetesClusterConfig {
      inherit config cfg profile;
    }
  );
}
