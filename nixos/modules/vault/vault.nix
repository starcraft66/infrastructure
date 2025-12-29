{ config, pkgs, lib, ... }:

let
  cfg = config.services.tdude.vault;
in lib.mkIf cfg.enable {
  environment.systemPackages = with pkgs; [ vault openssl ];
  environment.sessionVariables = {
    # Allow the vault CLI to hit the local vault instance, not the active VIP
    VAULT_ADDR = "https://${config.networking.hostName}.${config.networking.domain}:8200";
  };

  services.vault = {
    enable = true;
    tlsCertFile = "/var/lib/vault/vault-cert.pem";
    tlsKeyFile = "/var/lib/vault/vault-key.pem";
    # Use the binary version of vault which contains the vendored
    # dependencies. This is required for the vault UI to work.
    package = pkgs.vault-bin;
    address = "[::]:8200";
    storageBackend = "raft";
    storageConfig = let 
      mkRaftPeer = hostname: ''
        retry_join {
          leader_tls_servername = "${hostname}"
          leader_api_addr = "https://${hostname}:8200"
          leader_ca_cert_file = "/etc/ssl/certs/vault-ca.pem"
          leader_client_cert_file = "/var/lib/vault/vault-cert.pem"
          leader_client_key_file = "/var/lib/vault/vault-key.pem"
        }
      '';
    in ''
      node_id = "${config.networking.hostName}"
    '' + lib.concatStringsSep "\n" (map mkRaftPeer cfg.raftPeers);
    extraConfig = ''
      ui = true

      api_addr = "https://${cfg.hostname}"
      cluster_addr = "https://${config.networking.hostName}.${config.networking.domain}:8201"
      disable_mlock = false

      # tls_client_ca_file = "/etc/ssl/certs/vault-ca.pem"
    '';
  };

  security.acme.certs.vault = {
    group = "haproxy";
    domain = cfg.hostname;
    dnsProvider = "cloudflare";
    reloadServices = [ "haproxy" ];
  };
  
  networking.firewall.allowedTCPPorts = [ 8200 8201 ];
}
