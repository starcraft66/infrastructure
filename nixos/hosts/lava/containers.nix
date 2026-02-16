{ pkgs, ... }:

{
  virtualisation = {
    docker = {
      enable = true;
      storageDriver = "zfs";
      enableOnBoot = true;
      daemon.settings = {
        fixed-cidr-v6 = "fd00::/80";
        ipv6 = true;
        ip6tables = false; # We manage iptables rules ourselves since the docker one doesn't work with nftables and seems to conflict with the NixOS firewall
        live-restore = true;
      };
    };
  };

  # For docker userland proxy gitlab ssh port ipv6
  networking.firewall.interfaces.enp7s0.allowedTCPPorts = [ 80 443 5001 ];

  networking.firewall.trustedInterfaces = [ "docker0" ];

  # interfaces created by podman/docker compose bridges
  services.ndppd = {
    enable = true;
    interface = "enp7s0";
    proxies."enp7s0".rules = {
      "2a01:4f9:3051:104f:7::/80" = {
        method = "iface";
        interface = "br-matrix";
      };
      "2a01:4f9:3051:104f:8::/80" = {
        method = "iface";
        interface = "br-traefik";
      };
      "2a01:4f9:3051:104f:9::/80" = {
        method = "iface";
        interface = "br-kerio";
      };
      # "2a01:4f9:3051:104f:10::/80" = {
      #   method = "iface";
      #   interface = "docker0";
      # };
      # "2a01:4f9:3051:104f:1d0::/80" = {
      #   method = "iface";
      #   interface = "wg0";
      # };
      # "2a01:4f9:3051:104f:1d1::/80" = {
      #   method = "iface";
      #   interface = "wg0";
      # };
      # "2a01:4f9:3051:104f:1df::/80" = {
      #   method = "iface";
      #   interface = "wg0";
      # };
    };
  };
}
