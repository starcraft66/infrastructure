{ config, pkgs, lib, ... }:
let
  cfg = config.services.tdude.kubernetes.worker;
in
lib.mkIf cfg.enable {
  services.coredns = {
    # enable = true;
    enable = false;
    config = ''
      .:53 {
        errors
        health
        ready
        kubernetes cluster.local in-addr.arpa ip6.arpa {
          endpoint https://${config.networking.hostName}.${config.networking.domain}:6443
          tls /var/lib/secrets/coredns/coredns.pem /var/lib/secrets/coredns/coredns-key.pem /var/lib/secrets/coredns/kubernetes-ca.pem
          pods verified
          fallthrough in-addr.arpa ip6.arpa
        }
        prometheus :9153
        forward . ${lib.concatStringsSep " " config.networking.nameservers}
        cache 30
        loop
        reload
        loadbalance
      }
    '';
  };

  # Configure resolv.conf to point to local CoreDNS
  # networking.resolvconf.useLocalResolver = lib.mkIf cfg.enable true;
  services.resolved.dnssec = "false";

  # Don't use resolved, use coredns instead
  # services.resolved.enable = lib.mkIf cfg.enable (lib.mkForce false);

  # Using some relatively well-known IP addresses for the local DNS server
  # https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instancedata-data-retrieval.html

  networking.interfaces.dummy0.ipv4.addresses = [
    { address = "169.254.169.254"; prefixLength = 32; }
  ];

  networking.interfaces.dummy0.ipv6.addresses = [
    { address = "fd00:ec2::254"; prefixLength = 128; }
  ];

  # 200 iq logic in https://github.com/NixOS/nixpkgs/commit/26036ecf319c57700ce06bac8f44a956d8038c42
  # made `services.kubernetes.kubelet.clusterDns` completely useless if you have more than one resolver
  # we'll have to use the legacy cli option directly in cfg.extraOpts in `kubelet.nix` until I get this fixed upstream

  # services.kubernetes.kubelet.clusterDns = [ "169.254.169.254", "fd00:ec2::254" ];

  # Can't connect to the loopback v6 address because Cilium doesn't support NDP properly
  # note that this only seems to happen when both ipv4 and ipv6 are enabled in cilium
  # https://github.com/cilium/cilium/issues/16285
  # services.kubernetes.kubelet.clusterDns = [ "169.254.169.254" ];

  # When both ipv4 and ipv6 are enabled in cilium, access to the ipv4 loopback stops working
  # but access to the ipv6 loopback works fine
  # services.kubernetes.kubelet.clusterDns = [ "fd00:ec2::254" ];

  # services.kubernetes.kubelet.clusterDns = [ "2a10:4741:36:32:1::2558", "10.234.64.2" ];

  networking.firewall.allowedTCPPorts = [ 53 ];
  networking.firewall.allowedUDPPorts = [ 53 ];

  users.groups.coredns = { };
  users.users.coredns = {
    group = "coredns";
    isSystemUser = true;
  };

  systemd.services.coredns.after = [ "vault-agent-coredns.service" ];
}
