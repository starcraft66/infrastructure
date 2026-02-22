{ config, lib, ... }:

let
  cfg = config.services.tdude.patroni;
  # VRRP IDs 81-84 are used by k8s and vault (see kubernetes/loadbalancer/keepalived.nix)
  # Use 85 and 86 for PostgreSQL
in
lib.mkIf cfg.enable {
  services.keepalived.vrrpInstances.pg4 = {
    interface = cfg.interface;
    priority = 100; # same priority for everyone, round-robin
    virtualRouterId = 85;
    virtualIps = [ { addr = cfg.lbIpv4Address; } ];
  };
  services.keepalived.vrrpInstances.pg6 = {
    interface = cfg.interface;
    priority = 100; # same priority for everyone, round-robin
    virtualRouterId = 86;
    virtualIps = [ { addr = cfg.lbIpv6Address; } ];
  };
}
