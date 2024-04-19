{ ... }:
{
  security.acme.certs.turnserver = {
    domain = "turn.nerdsin.space";
    group = "turnserver";
    dnsProvider = "cloudflare";
    reloadServices = [ "coturn" ];
  };

  networking.firewall.interfaces.enp7s0.allowedTCPPorts = [ 3748 3749 5349 5350 ];

  services.coturn = {
    enable = true;
    use-auth-secret = true;
    static-auth-secret-file = "/var/lib/secrets/turn-secret";
    lt-cred-mech = true;
    realm = "turn.nerdsin.space";
    no-tcp-relay = true;
    no-cli = true;
    cert = "/var/lib/acme/turnserver/fullchain.pem";
    pkey = "/var/lib/acme/turnserver/key.pem";
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