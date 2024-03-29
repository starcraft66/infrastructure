{ config, lib, ... }:

let
  cfg = config.services.tdude.kubernetes.loadbalancer;
in lib.mkIf cfg.enable {
  services.keepalived = {
    enable = true;
    vrrpInstances.k8s4 = {
      interface = cfg.interface;
      priority = 100; # same priority for everyone, round-robin
      virtualRouterId = 81;
      virtualIps = [{ addr = cfg.k8sIpv4Address; }];
    };
    vrrpInstances.k8s6 = {
      interface = cfg.interface;
      priority = 100; # same priority for everyone, round-robin
      virtualRouterId = 82;
      virtualIps = [{ addr = cfg.k8sIpv6Address; }];
    };
    vrrpInstances.vault4 = {
      interface = cfg.interface;
      priority = 100; # same priority for everyone, round-robin
      virtualRouterId = 83;
      virtualIps = [{ addr = cfg.vaultIpv4Address; }];
    };
    vrrpInstances.vault6 = {
      interface = cfg.interface;
      priority = 100; # same priority for everyone, round-robin
      virtualRouterId = 84;
      virtualIps = [{ addr = cfg.vaultIpv6Address; }];
    };
  };

  boot.kernel.sysctl."net.ipv4.ip_nonlocal_bind" = true;
  boot.kernel.sysctl."net.ipv6.ip_nonlocal_bind" = true;

  networking.firewall.extraCommands = "iptables -A INPUT -p vrrp -j ACCEPT";
  networking.firewall.extraStopCommands = "iptables -D INPUT -p vrrp -j ACCEPT || true";
}