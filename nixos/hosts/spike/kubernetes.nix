{ config, pkgs, ... }: {
  imports = [
    ../../modules/kubernetes/controlplane
    ../../modules/kubernetes/etcd
    ../../modules/kubernetes/worker
    ../../modules/k8s-305-1700-1
  ];

  services.tdude.k8s-305-1700-1 = {
    enable = true;
    primaryNetworkInterface = "enp8s0";
    slaacAddress = "2a0c:9a46:637:51:e61d:2dff:fe27:dc10";
  };
}
