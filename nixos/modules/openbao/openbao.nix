{ config, pkgs, lib, ... }:

let
  cfg = config.services.tdude.openbao;
  credentialDirectory = "/run/credentials/openbao.service";
  mkRaftPeer = hostname: {
    leader_tls_servername = hostname;
    leader_api_addr = "https://${hostname}:8200";
    leader_ca_cert_file = "/etc/ssl/certs/vault-ca.pem";
    leader_client_cert_file = "${credentialDirectory}/tls-cert.pem";
    leader_client_key_file = "${credentialDirectory}/tls-key.pem";
  };
in
lib.mkIf cfg.enable {
  environment.systemPackages = with pkgs; [ openbao openssl ];
  environment.sessionVariables = {
    BAO_ADDR = "https://${config.networking.hostName}.${config.networking.domain}:8200";
    # The OpenTofu Vault provider and some existing automation still consume
    # this compatibility variable.
    VAULT_ADDR = "https://${config.networking.hostName}.${config.networking.domain}:8200";
  };

  services.openbao = {
    enable = true;
    settings = {
      ui = true;
      api_addr = "https://${cfg.hostname}";
      cluster_addr = "https://${config.networking.hostName}.${config.networking.domain}:8201";

      listener.default = {
        type = "tcp";
        address = "[::]:8200";
        tls_cert_file = "${credentialDirectory}/tls-cert.pem";
        tls_key_file = "${credentialDirectory}/tls-key.pem";
      };

      storage.raft = {
        path = "/var/lib/openbao";
        node_id = config.networking.hostName;
      } // lib.optionalAttrs (cfg.raftPeers != [ ]) {
        retry_join = map mkRaftPeer cfg.raftPeers;
      };
    };
  };

  systemd.services.openbao.serviceConfig.LoadCredential = [
    "tls-cert.pem:/var/lib/vault/vault-cert.pem"
    "tls-key.pem:/var/lib/vault/vault-key.pem"
  ];

  security.acme.certs.vault = {
    group = "haproxy";
    domain = cfg.hostname;
    dnsProvider = "cloudflare";
    reloadServices = [ "haproxy" ];
  };

  networking.firewall.allowedTCPPorts = [ 8200 8201 ];
}
