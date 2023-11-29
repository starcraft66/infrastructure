{ config, ... }: {
  imports = [ ../../modules/kubernetes/controlplane ../../modules/kubernetes/etcd ../../modules/kubernetes/worker ];

  services.tdude.kubernetes.control-plane.enable = true;
  services.tdude.kubernetes.control-plane.ipSans = [
    "10.234.64.1"
    "2a10:4741:36:32:1::1"
  ];
  services.tdude.kubernetes.control-plane.clusterCidrIpv4 = "10.234.128.0/18";
  services.tdude.kubernetes.control-plane.clusterCidrIpv6 = "2a10:4741:36:32:2::/104";
  services.tdude.kubernetes.control-plane.serviceCidrIpv4 = "10.234.64.0/18";
  services.tdude.kubernetes.control-plane.serviceCidrIpv6 = "2a10:4741:36:32:1::/112";
  services.tdude.kubernetes.worker.ipSans = [
    (builtins.elemAt config.networking.interfaces."eno3.29".ipv4.addresses 0).address
    (builtins.elemAt config.networking.interfaces."eno3.29".ipv6.addresses 0).address
    "2a10:4741:36:28:26be:5ff:fe84:d8b0" # slaac address, hardcoded for now
  ];
  services.tdude.kubernetes.worker.clusterCidrIpv4 = "10.234.128.0/18";
  services.tdude.kubernetes.worker.clusterCidrIpv6 = "2a10:4741:36:32:2::/104";
  services.tdude.kubernetes.etcd.enable = true;
  services.tdude.kubernetes.worker.enable = true;
  # Cilium replaces kube-proxy
  services.tdude.kubernetes.worker.kube-proxy.enable = false;

  networking.firewall.enable = false;
}
