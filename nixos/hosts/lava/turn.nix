{ ... }:
{
    security = {
    acme = {
      acceptTerms = true;
      defaults = {
        email = "tristan@tzone.org";
        credentialFiles = {
          CLOUDFLARE_DNS_API_TOKEN_FILE = "/var/lib/secrets/acme/cloudflare-api-token";
        };
      };
      certs = {
        turnserver = {
          hostnames = [ "turn.nerdsin.space" ];
          dnsProvider = [ "cloudflare" ];
          reloadServices = [ "coturn" ];
        };
      };
    };
  };

  services.coturn = {
    enable = true;
    use-auth-secret = true;
    static-auth-secret-file = "/etc/turn_secret";
    lt-cred-mech = true;
    realm = "turn.nerdsin.space";
    no-tcp-relay = true;
    no-cli = true;
    cert = "/var/lib/acme/vault/full.pem";
    pkey = "/var/lib/acme/vault/full.pem";
    listening-ips = [
      "65.109.116.164"
      "2a01:4f9:3051:104f::1"
    ];
    extraConfig = ''
      cipher-list="HIGH"
      denied-peer-ip=10.0.0.0-10.255.255.255
      denied-peer-ip=192.168.0.0-192.168.255.255
      denied-peer-ip=172.16.0.0-172.31.255.255
      denied-peer-ip=2a01:4f9:3051:104f::-2a01:4f9:3051:104f:ffff:ffff:ffff:ffff
      allowed-peer-ip=65.109.116.164
      allowed-peer-ip=2a01:4f9:3051:104f::1
    '';
  };
}