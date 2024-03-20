{ pkgs, ... }:

{
  virtualisation = {
    docker = {
      enable = true;
      storageDriver = "zfs";
      enableOnBoot = true;
    };
  };

  # interfaces created by podman/docker compose bridges
  services.ndppd.proxies."enp7s0".rules = {
    "2a01:4f9:3051:104f:7::/80" = {
      interface = "br-matrix";
    };
    "2a01:4f9:3051:104f:8::/80" = {
      interface = "br-traefik";
    };
    "2a01:4f9:3051:104f:9::/80" = {
      interface = "br-kerio";
    };
    "2a01:4f9:3051:104f:1d0::/80" = {
      interface = "wg0";
    };
    "2a01:4f9:3051:104f:1d1::/80" = {
      interface = "wg0";
    };
    "2a01:4f9:3051:104f:1df::/80" = {
      interface = "wg0";
    };
  };
}
