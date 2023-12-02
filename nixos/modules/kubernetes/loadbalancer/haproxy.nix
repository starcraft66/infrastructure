{ config, lib, ... }:
let
  cfg = config.services.tdude.kubernetes.loadbalancer;
  # TODO: Generate this from colmena nodes
  backends = map
    (hostname: "server ${builtins.head (lib.splitString "." hostname)} ${hostname}:6443")
    [
      "sassaflash.235.tdude.co"
      "stormfeather.235.tdude.co"
      "soarin.235.tdude.co"
    ];
in {
  services.haproxy = {
    enable = true;
    # TODO: backend healthchecks
    config = ''
      defaults
        timeout connect 10s

      frontend k8s
        mode tcp
        bind ${cfg.ipv4Address}:443
        bind ${cfg.ipv6Address}:443
        default_backend controlplanes

      backend controlplanes
        mode tcp
        ${builtins.concatStringsSep "\n  " backends}
    '';
  };
}