{ config, inputs, lib, pkgs, ... }:

let
  mkAlias = domain: recipient: sender: {
    name = "${sender}@${domain}";
    value = recipient;
  };
  mkTdudeAliases = aliases: lib.listToAttrs (map (mkAlias "tdude.co" "tristan@tdude.co") aliases);
  mkAS208914Aliases = aliases: lib.listToAttrs (map (mkAlias "as208914.net" "tristan@tdude.co") aliases);
in
{
  sops.secrets."mailserver-hashedpw-tristan@tdude.co" = { };
  sops.secrets."mailserver-hashedpw-git@tdude.co" = { };
  sops.secrets."mailserver-hashedpw-ups-235@tdude.co" = { };
  sops.secrets."mailserver-hashedpw-paperless@tdude.co" = { };

  services.monit = {
    config = lib.mkBefore ''
      set mail-format {
        from: monit@${config.networking.domain}
      }
    '';
  };

  services.nginx = {
    enable = true;
    virtualHosts.${config.mailserver.fqdn}.enableACME = true;
  };

  security.acme.certs.${config.mailserver.fqdn}.extraDomainNames = [
    config.networking.domain
    "smtp.${config.networking.domain}"
    "imap.${config.networking.domain}"
  ];

  mailserver = {
    enable = true;
    fqdn = "${config.networking.hostName}.${config.networking.domain}";
    domains = [ config.networking.domain "as208914.net" ];

    # Reference the existing ACME configuration created by nginx
    x509.useACMEHost = config.mailserver.fqdn;

    enableImap = true;
    enableImapSsl = true;
    enableSubmission = true;
    enableSubmissionSsl = true;

    accounts = {
      "tristan@tdude.co" = {
        hashedPasswordFile = config.sops.secrets."mailserver-hashedpw-tristan@tdude.co".path;
      };
      "git@tdude.co" = {
        hashedPasswordFile = config.sops.secrets."mailserver-hashedpw-git@tdude.co".path;
      };
      "ups-235@tdude.co" = {
        hashedPasswordFile = config.sops.secrets."mailserver-hashedpw-ups-235@tdude.co".path;
      };
      "paperless@tdude.co" = {
        hashedPasswordFile = config.sops.secrets."mailserver-hashedpw-paperless@tdude.co".path;
      };
    };
    aliases = {
      # ...
    } // mkTdudeAliases [ "webmaster" "minecraft1" "minecraft2" "minecraft3" "minecraft4" "steam1" "discord1" ]
      // mkAS208914Aliases [ "noc" "abuse" ];

    storage.directoryLayout = "fs";
    hierarchySeparator = "/";
    lmtpSaveToDetailMailbox = false;

    dkim.defaults.keyLength = 2048;

    monitoring.enable = true;
    monitoring.alertAddress = "starcraft66@gmail.com";

    stateVersion = 3;
  };
}