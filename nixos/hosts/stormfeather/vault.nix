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
        leader_tls_servername = "sassaflash.235.tdude.co"
        leader_api_addr = "https://sassaflash.235.tdude.co:8200"
        leader_ca_cert_file = "/etc/ssl/certs/vault-ca.pem"
        leader_client_cert_file = "/var/lib/vault/vault-cert.pem"
        leader_client_key_file = "/var/lib/vault/vault-key.pem"
      }
      retry_join {
        leader_tls_servername = "soarin.235.tdude.co"
        leader_api_addr = "https://soarin.235.tdude.co:8200"
        leader_ca_cert_file = "/etc/ssl/certs/vault-ca.pem"
        leader_client_cert_file = "/var/lib/vault/vault-cert.pem"
        leader_client_key_file = "/var/lib/vault/vault-key.pem"
      }
    '';
    extraConfig = ''
      ui = true

      api_addr = "https://vault.235.tdude.co"
      cluster_addr = "https://${config.networking.hostName}.235.tdude.co:8201"

      # tls_client_ca_file = "/etc/ssl/certs/vault-ca.pem"
    '';
  };

  security.acme.acceptTerms = true;
  security.acme.defaults.email = "tristan@tzone.org";
  security.acme.defaults.credentialFiles = {
    CLOUDFLARE_DNS_API_TOKEN_FILE = "/var/lib/secrets/acme/cloudflare-api-token";
  };

  security.acme.certs.vault = {
    group = "haproxy";
    domain = "vault.235.tdude.co";
    dnsProvider = "cloudflare";
  };
  
  networking.firewall.allowedTCPPorts = [ 8200 8201 ];
}
