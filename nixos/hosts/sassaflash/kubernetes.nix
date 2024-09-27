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
    slaacAddress = "2a10:4741:36:28:26be:5ff:fe84:d8b0";
  };
}
