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

  mailserver = {
    enable = true;
    fqdn = "${config.networking.hostName}.${config.networking.domain}";
    domains = [ config.networking.domain "as208914.net" ];
    certificateDomains = [
      config.networking.domain
      "${config.networking.hostName}.${config.networking.domain}"
      "smtp.${config.networking.domain}"
      "imap.${config.networking.domain}"
    ];

    enableImap = true;
    enableImapSsl = true;
    enableSubmission = true;
    enableSubmissionSsl = true;

    loginAccounts = {
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
    extraVirtualAliases = {
      # ...
    } // mkTdudeAliases [ "webmaster" "minecraft1" "minecraft2" "minecraft3" "minecraft4" "steam1" "discord1" ]
      // mkAS208914Aliases [ "noc" "abuse" ];

    useFsLayout = true;
    hierarchySeparator = "/";
    lmtpSaveToDetailMailbox = "no";

    dkimKeyBits = 2048;

    monitoring.enable = true;
    monitoring.alertAddress = "starcraft66@gmail.com";

    certificateScheme = "acme-nginx";
  };
}