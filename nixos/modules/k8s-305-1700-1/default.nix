{ config
, inputs
, lib
, pkgs
, ...
}:

let
  cfg = config.services.tdude.k8s-305-1700-1;
  profile = inputs.self.lib.kubernetesClusters."k8s-305-1700-1";
  mkKubernetesClusterConfig = import ../../lib/mk-kubernetes-cluster-config.nix { inherit lib; };
in
{
  options.services.tdude.k8s-305-1700-1 = {
    enable = lib.mkEnableOption "Enable the k8s-305-1700-1 node role";
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
    lib.mkMerge [
      (mkKubernetesClusterConfig {
        inherit config cfg profile;
      })
      {
        # Multus for the Home Assistant host bridge.
        systemd.tmpfiles.rules = [
          "d /etc/cni/multus.d 0770 root root -"
        ];
        services.kubernetes.kubelet.cni.packages = with pkgs; [ multus-cni ];
        services.kubernetes.kubelet.cni.config = lib.mkForce [
          {
            name = "multus-cni-network";
            type = "multus";
            capabilities.portMappings = true;
            delegates = [
              {
                cniVersion = "0.3.1";
                name = "default-cni-network";
                plugins = [
                  {
                    name = "cilium";
                    type = "cilium-cni";
                  }
                ];
              }
            ];
            kubeconfig = "/etc/cni/multus.d/multus.kubeconfig";
          }
        ];
        services.tdude.kubernetes.worker.nvidia.enable = true;
      }
    ]
  );
}
