{ config, ... }: {
  imports = [
    ../../modules/kubernetes/controlplane
    ../../modules/kubernetes/etcd
    ../../modules/kubernetes/worker
    ../../modules/k8s-235-1
  ];

  services.tdude.k8s-235-1 = {
    enable = true;
    primaryNetworkInterface = "eno1.29";
  };
}
