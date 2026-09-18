{ config, lib, ... }:
let
  cfg = config.services.tdude.kubernetes.control-plane;
  k8s = config.services.kubernetes.controllerManager;
in {
  services.kubernetes.controllerManager = {
    enable = lib.mkIf cfg.enable true;
    bindAddress = "::";
    # PodCIDRs are allocated by Cilium's multi-pool IPAM (CiliumPodIPPool),
    # so kube-controller-manager must not allocate node CIDRs.
    # https://docs.cilium.io/en/stable/network/concepts/ipam/multi-pool/
    allocateNodeCIDRs = false;

    extraOpts =
      ''--node-cidr-mask-size-ipv4 24 \
        --node-cidr-mask-size-ipv6 120 \
        --service-cluster-ip-range=${config.services.kubernetes.apiserver.serviceClusterIpRange} \
        --authorization-kubeconfig=${config.services.kubernetes.lib.mkKubeConfig "kube-controller-manager" config.services.kubernetes.controllerManager.kubeconfig} \
        --authentication-kubeconfig=${config.services.kubernetes.lib.mkKubeConfig "kube-controller-manager" config.services.kubernetes.controllerManager.kubeconfig}
      '';

    serviceAccountKeyFile = "/var/lib/secrets/kubernetes/service-account-key.pem";
    rootCaFile = "/var/lib/secrets/kubernetes/kubernetes-ca.pem";

    kubeconfig = {
      caFile = "/var/lib/secrets/kubernetes/kubernetes-ca.pem";
      certFile = "/var/lib/secrets/kubernetes/kube-controller-manager.pem";
      keyFile = "/var/lib/secrets/kubernetes/kube-controller-manager-key.pem";
      server = "https://${config.networking.hostName}.${config.networking.domain}:6443";
    };
  };
}
