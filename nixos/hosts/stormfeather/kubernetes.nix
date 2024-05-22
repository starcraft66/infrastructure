{ config, ... }: {
  imports = [ ../../modules/kubernetes/controlplane ../../modules/kubernetes/etcd ../../modules/kubernetes/worker ];

  services.tdude.kubernetes.control-plane.enable = true;
  services.tdude.kubernetes.control-plane.ipSans = [
    "10.234.64.1"
    "2a10:4741:36:32:1::1"
  ];
  services.tdude.kubernetes.control-plane.additionalApiserverAltNames = [ "k8s.235.tdude.co" ];
  services.tdude.kubernetes.control-plane.clusterCidrIpv4 = "10.234.128.0/18";
  services.tdude.kubernetes.control-plane.clusterCidrIpv6 = "2a10:4741:36:32:2::/104";
  services.tdude.kubernetes.control-plane.serviceCidrIpv4 = "10.234.64.0/18";
  services.tdude.kubernetes.control-plane.serviceCidrIpv6 = "2a10:4741:36:32:1::/112";
  services.tdude.kubernetes.worker.ipSans = [
    (builtins.elemAt config.networking.interfaces."enp10s0.29".ipv4.addresses 0).address
    (builtins.elemAt config.networking.interfaces."enp10s0.29".ipv6.addresses 0).address
    "2a10:4741:36:29:202:c9ff:fe9d:c36a" # slaac address, hardcoded for now
  ];
  services.tdude.kubernetes.worker.clusterCidrIpv4 = "10.234.128.0/18";
  services.tdude.kubernetes.worker.clusterCidrIpv6 = "2a10:4741:36:32:2::/104";
  services.tdude.kubernetes.etcd.enable = true;
  services.tdude.kubernetes.worker.enable = true;
  # Cilium replaces kube-proxy
  services.tdude.kubernetes.worker.kube-proxy.enable = true;
  services.tdude.kubernetes.loadbalancer.enable = true;
  services.tdude.kubernetes.loadbalancer.interface = "enp10s0.29";
  services.tdude.kubernetes.loadbalancer.k8sIpv4Address = "172.16.29.8";
  services.tdude.kubernetes.loadbalancer.k8sIpv6Address = "2a10:4741:36:29::8:1";
  services.tdude.kubernetes.loadbalancer.vaultIpv4Address = "172.16.29.9";
  services.tdude.kubernetes.loadbalancer.vaultIpv6Address = "2a10:4741:36:29::9:1";

  services.tdude.vault.enable = true;
  services.tdude.vault.raftPeers = [
    "soarin.235.tdude.co"
    "sassaflash.235.tdude.co"
  ];

  networking.firewall.enable = false;
}
