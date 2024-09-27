{ config, ... }: {
  imports = [
    ../../modules/kubernetes/controlplane
    ../../modules/kubernetes/etcd
    ../../modules/kubernetes/worker
    ../../modules/k8s-235-1
  ];

  services.tdude.k8s-235-1 = {
    enable = true;
    primaryNetworkInterface = "enp10s0.29";
    slaacAddress = "2a10:4741:36:29:202:c9ff:fe9d:c36a";
  };
}
