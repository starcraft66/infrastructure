{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [ vault openssl ];

  services.vault = {
    enable = true;
    tlsCertFile = "/var/lib/vault/vault-cert.pem";
    tlsKeyFile = "/var/lib/vault/vault-key.pem";
    # Use the binary version of vault which contains the vendored
    # dependencies. This is required for the vault UI to work.
    package = pkgs.vault-bin;
    address = "[::]:8200";
    storageBackend = "raft";
    # TODO: Generate the storage config based on the colmena nodes
    storageConfig = ''
      node_id = "${config.networking.hostName}"
      retry_join {
        leader_tls_servername = "stormfeather.235.tdude.co"
        leader_api_addr = "https://stormfeather.235.tdude.co:8200"
        leader_ca_cert_file = "/etc/ssl/certs/vault-ca.pem"
        leader_client_cert_file = "/var/lib/vault/vault-cert.pem"
        leader_client_key_file = "/var/lib/vault/vault-key.pem"
      }
    '';
    extraConfig = ''
      ui = true

      api_addr = "http://${config.networking.hostName}.235.tdude.co:8200"
      cluster_addr = "https://${config.networking.hostName}.235.tdude.co:8201"

      # tls_client_ca_file = "/etc/ssl/certs/vault-ca.pem"
    '';
  };
  
  networking.firewall.allowedTCPPorts = [ 8200 8201 ];
}
