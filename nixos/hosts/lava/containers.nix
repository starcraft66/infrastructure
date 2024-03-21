{ pkgs, ... }:

{
  virtualisation = {
    docker = {
      enable = true;
      storageDriver = "zfs";
      enableOnBoot = true;
    };
  };

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
