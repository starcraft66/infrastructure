{ config, lib, ... }:
let
  cfg = config.services.tdude.kubernetes.loadbalancer;
  # TODO: Generate this from colmena nodes
  vaultBackend = (hostname: "server ${builtins.head (lib.splitString "." hostname)} ${hostname}:8200 ssl verify required ca-file /etc/ssl/certs/vault-ca.pem check inter 10s fall 3 rise 2 sni str(${cfg.vaultSNI})");
  k8sBackend = (hostname: "server ${builtins.head (lib.splitString "." hostname)} ${hostname}:6443 check inter 10s fall 3 rise 2");
  backends = backend: map backend cfg.k8sBackendHostnames;
in {
  services.haproxy = lib.mkIf cfg.enable {
    enable = true;
    config = ''
      defaults
        timeout connect 10s

      frontend k8s
        mode tcp
        bind ${cfg.k8sIpv4Address}:443
        bind ${cfg.k8sIpv6Address}:443
        default_backend controlplanes

      frontend vault
        mode tcp
        bind ${cfg.vaultIpv4Address}:443 ssl crt /var/lib/acme/vault/full.pem
        bind ${cfg.vaultIpv6Address}:443 ssl crt /var/lib/acme/vault/full.pem
        default_backend vaults

      backend controlplanes
        mode tcp
        option tcp-check
        balance roundrobin
        ${builtins.concatStringsSep "\n  " (backends k8sBackend)}

      backend vaults
        mode tcp
        balance roundrobin
        ${builtins.concatStringsSep "\n  " (backends vaultBackend)}
    '';
  };
}