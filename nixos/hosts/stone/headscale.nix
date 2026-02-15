{ config, ... }:

let
  vpnDomain = "vpn.tdude.co";
in {
  services = {
    headscale = {
      enable = true;
      address = "[::1]";
      port = 48372;
      settings = {
        server_url = "https://${vpnDomain}";
        dns = {
          base_domain = "d.${vpnDomain}";
          override_local_dns = false;
        };
      };
      settings = { logtail.enabled = false; };
    };

    nginx.virtualHosts.${vpnDomain} = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass =
          "http://${config.services.headscale.address}:${toString config.services.headscale.port}";
        proxyWebsockets = true;
      };
    };
  };

  environment.systemPackages = [ config.services.headscale.package ];
}