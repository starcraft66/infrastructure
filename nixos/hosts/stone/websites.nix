{ config, lib, pkgs, inputs, ... }:

{
  networking.firewall.interfaces.ens3.allowedTCPPorts = [ 80 443 ];
  security = {
    acme = {
      acceptTerms = true;
      defaults = {
        email = "tristan@tzone.org";
      };
    };
  };
  services = {
    nginx = {
      enable = true;
      recommendedTlsSettings = true;
      virtualHosts = {
        "www.tdude.co" = {
          enableACME = true;
          forceSSL = true;
          root = inputs.tdude-website.packages.x86_64-linux.tdude-website;
        };
        # Need to set this to the fqdn of the simple nixos mailserver config
        # because it hijacks the vhost "tdude.co" is under as an alias to generate
        # the cert for the mailserver.
        "stone.tdude.co" = {
          enableACME = true;
          forceSSL = true;
          locations."/".return = "301 https://www.tdude.co$request_uri";
        };
        "www.shitsta.in" = {
          enableACME = true;
          forceSSL = true;
          root = "/var/www/www.shitsta.in";
        };
        shitstain-tor = {
          root = "/var/www/www.shitsta.in";
          listen = [ { addr = "[::1]"; port = 8080; ssl = false; } ];
          serverName = "www.shitsta.in";
        };
        "shitsta.in" = {
          enableACME = true;
          forceSSL = true;
          locations."/".return = "301 https://www.shitsta.in$request_uri";
        };
      };
    };
  };
}
