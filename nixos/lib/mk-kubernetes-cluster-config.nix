{ lib }:

{ config
, cfg
, profile
,
}:

let
  currentFqdn = "${config.networking.hostName}.${config.networking.domain}";
  memberHostnames = builtins.attrValues profile.memberFqdns;
  nodeIpv4 = (builtins.elemAt config.networking.interfaces.${cfg.primaryNetworkInterface}.ipv4.addresses 0).address;
  nodeIpv6 = (builtins.elemAt config.networking.interfaces.${cfg.primaryNetworkInterface}.ipv6.addresses 0).address;
  vaultAgentUrl = "https://[::1]:8200";
in
{
  assertions = [
    {
      assertion = builtins.hasAttr config.networking.hostName profile.memberFqdns;
      message = "${currentFqdn} is not a member of ${profile.clusterName}";
    }
  ];

  services.tdude.kubernetes.control-plane = {
    enable = true;
    ipSans = builtins.attrValues profile.apiServiceIps;
    additionalApiserverAltNames = [ profile.domains.kubernetes ];
    clusterCidrIpv4 = profile.podCidrs.ipv4;
    clusterCidrIpv6 = profile.podCidrs.ipv6;
    serviceCidrIpv4 = profile.serviceCidrs.ipv4;
    serviceCidrIpv6 = profile.serviceCidrs.ipv6;
    oidcIssuerUrl = "https://${profile.domains.pocketId}";
    inherit (profile) oidcClientId;
    etcdServerUrls = map (hostname: "https://${hostname}:2379") memberHostnames;
    pki = {
      vaultURL = vaultAgentUrl;
      vaultSNI = profile.domains.vault;
      inherit (profile) clusterName;
    };
  };

  services.tdude.kubernetes.etcd = {
    enable = true;
    inherit (profile) initialClusterState;
    initialClusterPeers = lib.mapAttrs (_: hostname: { inherit hostname; }) profile.memberFqdns;
    pki = {
      vaultURL = vaultAgentUrl;
      vaultSNI = profile.domains.vault;
      inherit (profile) clusterName;
    };
  };

  services.tdude.kubernetes.worker = {
    enable = true;
    ipSans = [ nodeIpv4 nodeIpv6 cfg.slaacAddress ];
    clusterCidrIpv4 = profile.podCidrs.ipv4;
    clusterCidrIpv6 = profile.podCidrs.ipv6;
    nodeIps = [ nodeIpv4 nodeIpv6 ];
    dnsResolvers = [ profile.corednsServiceIps.ipv6 profile.corednsServiceIps.ipv4 ];
    apiserverAddress = "https://${currentFqdn}:6443";
    kube-proxy.enable = false;
    pki = {
      vaultURL = vaultAgentUrl;
      vaultSNI = profile.domains.vault;
      inherit (profile) clusterName;
    };
  };

  services.tdude.kubernetes.loadbalancer = {
    enable = true;
    interface = cfg.primaryNetworkInterface;
    k8sIpv4Address = profile.vips.kubernetes.ipv4;
    k8sIpv6Address = profile.vips.kubernetes.ipv6;
    k8sBackendHostnames = memberHostnames;
    vaultIpv4Address = profile.vips.vault.ipv4;
    vaultIpv6Address = profile.vips.vault.ipv6;
    vaultSNI = profile.domains.vault;
  };

  services.tdude.vault = {
    enable = true;
    raftPeers = lib.remove currentFqdn memberHostnames;
    hostname = profile.domains.vault;
  };

  services.tdude.patroni = {
    enable = true;
    clusterName = "pg-${lib.removePrefix "k8s-" profile.clusterName}";
    clusterMembers = profile.memberFqdns;
    etcdUrls = map (hostname: "https://${hostname}:2379") memberHostnames;
    interface = cfg.primaryNetworkInterface;
    environmentFile = "/var/lib/secrets/patroni/environment";
    synchronousMode = profile.patroniSynchronousMode;
    pgHbaNetworks = [ profile.lanCidrs ];
    lbIpv4Address = profile.vips.postgres.ipv4;
    lbIpv6Address = profile.vips.postgres.ipv6;
    pki = {
      vaultURL = vaultAgentUrl;
      vaultSNI = profile.domains.vault;
      inherit (profile) clusterName;
    };
  };

  services.tdude.pocket-id = {
    enable = true;
    domain = profile.domains.pocketId;
    environmentFile = "/var/lib/secrets/pocket-id/environment";
    interface = cfg.primaryNetworkInterface;
    lbIpv4Address = profile.vips.pocketId.ipv4;
    lbIpv6Address = profile.vips.pocketId.ipv6;
  };

  networking.firewall.enable = false;
}
