{ lib, ...}:

let
  cfg = config.services.tdude.kubernetes.loadbalancer;
in lib.mkIf cfg.enable {
  services.keepalived = {
    enable = true;
    vrrpInstances.k8s = {
      interface = "eno1.29";
      priority = 100; # same priority for everyone, round-robin
      virtualRouterId = 42;
      virtualIps = [{ addr = virtualIP; }];
    };
  };

  boot.kernel.sysctl."net.ipv4.ip_nonlocal_bind" = true;
  boot.kernel.sysctl."net.ipv6.ip_nonlocal_bind" = true;

  networking.firewall.extraCommands = "iptables -A INPUT -p vrrp -j ACCEPT";
  networking.firewall.extraStopCommands = "iptables -D INPUT -p vrrp -j ACCEPT || true";
}