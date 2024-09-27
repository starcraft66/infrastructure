{ config, lib, ... }:

let
  clusterCidrIpv4 = "10.235.128.0/18";
  clusterCidrIpv6 = "2a10:4741:37:88:2::/104";
  serviceCidrIpv4 = "10.235.64.0/18";
  serviceCidrIpv6 = "2a10:4741:37:88:1::/112";
  apiserverK8sSvcAdresses = [ "10.235.64.1" "2a10:4741:37:88:1::1" ];
  oidcIssuerUrl = "https://vault.305-1700.tdude.co/v1/identity/oidc/provider/default";
  oidcClientId = "2Fxqqt0TCnkjcIO2Q7YUI3da8HJVCkik";
  clusterMembers = {
    spike = "spike.305-1700.tdude.co";
  };
  dnsResolvers = [ "2a10:4741:37:88:1::2" "10.235.64.2" ];
  vaultAgentVaultURL = "https://[::1]:8200";
  vaultAgentVaultSNI = "vault.305-1700.tdude.co";
  lbK8sIpv4Address = "172.17.51.8";
  lbK8sIpv6Address = "2a10:4741:37:51::8:1";
  lbK8sDomain = "k8s.305-1700.tdude.co";
  lbVaultIpv4Address = "172.17.51.9";
  lbVaultIpv6Address = "2a10:4741:37:51::9:1";
  lbVaultDomain = "vault.305-1700.tdude.co";
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
    services.tdude.kubernetes.control-plane.enable = true;
    services.tdude.kubernetes.control-plane.ipSans = apiserverK8sSvcAdresses;
    services.tdude.kubernetes.control-plane.additionalApiserverAltNames = [ lbK8sDomain ];
    services.tdude.kubernetes.control-plane.clusterCidrIpv4 = clusterCidrIpv4;
    services.tdude.kubernetes.control-plane.clusterCidrIpv6 = clusterCidrIpv6;
    services.tdude.kubernetes.control-plane.serviceCidrIpv4 = serviceCidrIpv4;
    services.tdude.kubernetes.control-plane.serviceCidrIpv6 = serviceCidrIpv6;
    services.tdude.kubernetes.control-plane.oidcIssuerUrl = oidcIssuerUrl;
    services.tdude.kubernetes.control-plane.oidcClientId = oidcClientId;
    services.tdude.kubernetes.control-plane.etcdServerUrls = lib.mapAttrsToList (name: hostname: "https://${hostname}:2379") clusterMembers; 
    services.tdude.kubernetes.worker.ipSans = [
      (builtins.elemAt config.networking.interfaces.${cfg.primaryNetworkInterface}.ipv4.addresses 0).address
      (builtins.elemAt config.networking.interfaces.${cfg.primaryNetworkInterface}.ipv6.addresses 0).address
      cfg.slaacAddress
    ];
    services.tdude.kubernetes.worker.clusterCidrIpv4 = clusterCidrIpv4;
    services.tdude.kubernetes.worker.clusterCidrIpv6 = clusterCidrIpv6;
    services.tdude.kubernetes.etcd.enable = true;
    services.tdude.kubernetes.etcd.initialClusterState = "new";
    services.tdude.kubernetes.etcd.initialClusterPeers = lib.mapAttrs (name: hostname: { hostname = hostname; }) clusterMembers;
    services.tdude.kubernetes.worker.enable = true;
    services.tdude.kubernetes.worker.nodeIps = [
      (builtins.elemAt config.networking.interfaces.${cfg.primaryNetworkInterface}.ipv4.addresses 0).address
      (builtins.elemAt config.networking.interfaces.${cfg.primaryNetworkInterface}.ipv6.addresses 0).address
    ];
    services.tdude.kubernetes.worker.dnsResolvers = dnsResolvers;
    # Hit the api server directly on the host since we're running the control plane and workers on the same nodes in this cluster
    services.tdude.kubernetes.worker.apiserverAddress = "https://${config.networking.hostName}.${config.networking.domain}:6443";
    # Cilium replaces kube-proxy
    services.tdude.kubernetes.worker.kube-proxy.enable = false;
    services.tdude.kubernetes.loadbalancer.enable = true;
    services.tdude.kubernetes.loadbalancer.interface = cfg.primaryNetworkInterface;
    services.tdude.kubernetes.loadbalancer.k8sIpv4Address = lbK8sIpv4Address;
    services.tdude.kubernetes.loadbalancer.k8sIpv6Address = lbK8sIpv6Address;
    services.tdude.kubernetes.loadbalancer.k8sBackendHostnames = lib.mapAttrsToList (name: hostname: hostname) clusterMembers;
    services.tdude.kubernetes.loadbalancer.vaultIpv4Address = lbVaultIpv4Address;
    services.tdude.kubernetes.loadbalancer.vaultIpv6Address = lbVaultIpv6Address;
    services.tdude.kubernetes.loadbalancer.vaultSNI = lbVaultDomain;

    services.tdude.vault.enable = true;
    # All nodes minus the current one
    services.tdude.vault.raftPeers = let
        nodes = lib.mapAttrsToList (name: hostname: hostname) clusterMembers;
      in lib.remove "${config.networking.hostName}.${config.networking.domain}" nodes;

    services.tdude.vault.hostname = lbVaultDomain;

    services.tdude.kubernetes.control-plane.pki.vaultURL = vaultAgentVaultURL;
    services.tdude.kubernetes.control-plane.pki.vaultSNI = vaultAgentVaultSNI;
    services.tdude.kubernetes.etcd.pki.vaultURL = vaultAgentVaultURL;
    services.tdude.kubernetes.etcd.pki.vaultSNI = vaultAgentVaultSNI;
    services.tdude.kubernetes.worker.pki.vaultURL = vaultAgentVaultURL;
    services.tdude.kubernetes.worker.pki.vaultSNI = vaultAgentVaultSNI;

    networking.firewall.enable = false;
  };
}