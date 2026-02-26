{
  config,
  lib,
  pkgs,
  ...
}:

let
  clusterName = "k8s-305-1700-1";
  clusterCidrIpv4 = "10.235.128.0/18";
  clusterCidrIpv6 = "2a0c:9a46:637:88:2::/104";
  serviceCidrIpv4 = "10.235.64.0/18";
  serviceCidrIpv6 = "2a0c:9a46:637:88:1::/112";
  apiserverK8sSvcAdresses = [
    "10.235.64.1"
    "2a0c:9a46:637:88:1::1"
  ];
  oidcIssuerUrl = "https://vault.305-1700.tdude.co/v1/identity/oidc/provider/default";
  oidcClientId = "hJ6PJMNvxsEzL7UMHQUev1bziLbxFdPO";
  clusterMembers = {
    spike = "spike.305-1700.tdude.co";
  };
  dnsResolvers = [
    "2a0c:9a46:637:88:1::2"
    "10.235.64.2"
  ];
  vaultAgentVaultURL = "https://[::1]:8200";
  vaultAgentVaultSNI = "vault.305-1700.tdude.co";
  lbK8sIpv4Address = "172.17.51.8";
  lbK8sIpv6Address = "2a0c:9a46:637:51::8:1";
  lbK8sDomain = "k8s.305-1700.tdude.co";
  lbVaultIpv4Address = "172.17.51.9";
  lbVaultIpv6Address = "2a0c:9a46:637:51::9:1";
  lbVaultDomain = "vault.305-1700.tdude.co";
  lbPgIpv4Address = "172.17.51.10";
  lbPgIpv6Address = "2a0c:9a46:637:51::10:1";
  lbPocketIdIpv4Address = "172.17.51.11";
  lbPocketIdIpv6Address = "2a0c:9a46:637:51::11:1";
  pocketIdDomain = "id.305-1700.tdude.co";
  cfg = config.services.tdude.k8s-305-1700-1;
in
{
  options.services.tdude.k8s-305-1700-1 = with lib; {
    enable = mkEnableOption "Enable the k8s-305-1700-1 node role";
    primaryNetworkInterface = mkOption {
      type = types.str;
      description = "The primary network interface for the node";
    };
    slaacAddress = mkOption {
      type = types.str;
      description = "The slaac address for the node";
    };
  };

  config = lib.mkIf cfg.enable {
    # Multus for Home Assistant host bridge
    systemd.tmpfiles.rules = [
      "d /etc/cni/multus.d 0770 root root -"
    ];
    services.kubernetes.kubelet.cni.packages = with pkgs; [ multus-cni ];
    services.kubernetes.kubelet.cni.config = lib.mkForce [
      {
        name = "multus-cni-network";
        type = "multus";
        capabilities = {
          portMappings = true;
        };
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

    services.tdude.kubernetes.control-plane.enable = true;
    services.tdude.kubernetes.control-plane.ipSans = apiserverK8sSvcAdresses;
    services.tdude.kubernetes.control-plane.additionalApiserverAltNames = [ lbK8sDomain ];
    services.tdude.kubernetes.control-plane.clusterCidrIpv4 = clusterCidrIpv4;
    services.tdude.kubernetes.control-plane.clusterCidrIpv6 = clusterCidrIpv6;
    services.tdude.kubernetes.control-plane.serviceCidrIpv4 = serviceCidrIpv4;
    services.tdude.kubernetes.control-plane.serviceCidrIpv6 = serviceCidrIpv6;
    services.tdude.kubernetes.control-plane.oidcIssuerUrl = oidcIssuerUrl;
    services.tdude.kubernetes.control-plane.oidcClientId = oidcClientId;
    services.tdude.kubernetes.control-plane.etcdServerUrls = lib.mapAttrsToList (
      name: hostname: "https://${hostname}:2379"
    ) clusterMembers;
    services.tdude.kubernetes.worker.ipSans = [
      (builtins.elemAt config.networking.interfaces.${cfg.primaryNetworkInterface}.ipv4.addresses 0)
      .address
      (builtins.elemAt config.networking.interfaces.${cfg.primaryNetworkInterface}.ipv6.addresses 0)
      .address
      cfg.slaacAddress
    ];
    services.tdude.kubernetes.worker.clusterCidrIpv4 = clusterCidrIpv4;
    services.tdude.kubernetes.worker.clusterCidrIpv6 = clusterCidrIpv6;
    services.tdude.kubernetes.etcd.enable = true;
    services.tdude.kubernetes.etcd.initialClusterState = "new";
    services.tdude.kubernetes.etcd.initialClusterPeers = lib.mapAttrs (name: hostname: {
      hostname = hostname;
    }) clusterMembers;
    services.tdude.kubernetes.worker.enable = true;
    services.tdude.kubernetes.worker.nvidia.enable = true;
    services.tdude.kubernetes.worker.nodeIps = [
      (builtins.elemAt config.networking.interfaces.${cfg.primaryNetworkInterface}.ipv4.addresses 0)
      .address
      (builtins.elemAt config.networking.interfaces.${cfg.primaryNetworkInterface}.ipv6.addresses 0)
      .address
    ];
    services.tdude.kubernetes.worker.dnsResolvers = dnsResolvers;
    # Hit the api server directly on the host since we're running the control plane and workers on the same nodes in this cluster
    services.tdude.kubernetes.worker.apiserverAddress =
      "https://${config.networking.hostName}.${config.networking.domain}:6443";
    # Cilium replaces kube-proxy
    services.tdude.kubernetes.worker.kube-proxy.enable = false;
    services.tdude.kubernetes.loadbalancer.enable = true;
    services.tdude.kubernetes.loadbalancer.interface = cfg.primaryNetworkInterface;
    services.tdude.kubernetes.loadbalancer.k8sIpv4Address = lbK8sIpv4Address;
    services.tdude.kubernetes.loadbalancer.k8sIpv6Address = lbK8sIpv6Address;
    services.tdude.kubernetes.loadbalancer.k8sBackendHostnames = lib.mapAttrsToList (
      name: hostname: hostname
    ) clusterMembers;
    services.tdude.kubernetes.loadbalancer.vaultIpv4Address = lbVaultIpv4Address;
    services.tdude.kubernetes.loadbalancer.vaultIpv6Address = lbVaultIpv6Address;
    services.tdude.kubernetes.loadbalancer.vaultSNI = lbVaultDomain;

    services.tdude.vault.enable = true;
    # All nodes minus the current one
    services.tdude.vault.raftPeers =
      let
        nodes = lib.mapAttrsToList (name: hostname: hostname) clusterMembers;
      in
      lib.remove "${config.networking.hostName}.${config.networking.domain}" nodes;

    services.tdude.vault.hostname = lbVaultDomain;

    services.tdude.kubernetes.control-plane.pki.vaultURL = vaultAgentVaultURL;
    services.tdude.kubernetes.control-plane.pki.vaultSNI = vaultAgentVaultSNI;
    services.tdude.kubernetes.control-plane.pki.clusterName = clusterName;
    services.tdude.kubernetes.etcd.pki.vaultURL = vaultAgentVaultURL;
    services.tdude.kubernetes.etcd.pki.vaultSNI = vaultAgentVaultSNI;
    services.tdude.kubernetes.etcd.pki.clusterName = clusterName;
    services.tdude.kubernetes.worker.pki.vaultURL = vaultAgentVaultURL;
    services.tdude.kubernetes.worker.pki.vaultSNI = vaultAgentVaultSNI;
    services.tdude.kubernetes.worker.pki.clusterName = clusterName;

    # Patroni PostgreSQL cluster (single-node)
    services.tdude.patroni.enable = true;
    services.tdude.patroni.clusterName = "pg-305-1700-1";
    services.tdude.patroni.clusterMembers = clusterMembers;
    services.tdude.patroni.etcdUrls = lib.mapAttrsToList (
      name: hostname: "https://${hostname}:2379"
    ) clusterMembers;
    services.tdude.patroni.interface = cfg.primaryNetworkInterface;
    services.tdude.patroni.environmentFile = "/var/lib/secrets/patroni/environment";
    services.tdude.patroni.synchronousMode = false;
    services.tdude.patroni.pgHbaNetworks = [
      {
        ipv4 = "172.17.51.0/24";
        ipv6 = "2a0c:9a46:637:51::/64";
      }
    ];
    services.tdude.patroni.lbIpv4Address = lbPgIpv4Address;
    services.tdude.patroni.lbIpv6Address = lbPgIpv6Address;
    services.tdude.patroni.pki.vaultURL = vaultAgentVaultURL;
    services.tdude.patroni.pki.vaultSNI = vaultAgentVaultSNI;
    services.tdude.patroni.pki.clusterName = clusterName;

    # Pocket ID OIDC provider
    services.tdude.pocket-id.enable = true;
    services.tdude.pocket-id.domain = pocketIdDomain;
    services.tdude.pocket-id.environmentFile = "/var/lib/secrets/pocket-id/environment";
    services.tdude.pocket-id.interface = cfg.primaryNetworkInterface;
    services.tdude.pocket-id.lbIpv4Address = lbPocketIdIpv4Address;
    services.tdude.pocket-id.lbIpv6Address = lbPocketIdIpv6Address;

    networking.firewall.enable = false;
  };
}
