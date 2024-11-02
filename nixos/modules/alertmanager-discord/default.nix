{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.alertmanager-discord;
in
{
  options.services.alertmanager-discord = {
    enable = mkEnableOption {
      default = false;
      description = ''
        Enable the alertmanager-discord service.
      '';
    };
    address = mkOption {
      type = types.str;
      default = "[::1]:9095";
      description = ''
        The address to listen on for HTTP requests. The default is
        :code:`[::1]:9095`.
      '';
    };
    webhookFile = mkOption {
      type = types.str;
      default = "";
      description = ''
        The path to the webhook file. The default is
        :code:``.
      '';
    };
  };

  config = lib.mkMerge [
    (lib.mkIf
      cfg.enable
      {
        environment.systemPackages = [ pkgs.alertmanager-discord ];
        systemd.services.alertmanager-discord = {
          description = "Take your alertmanager alerts, into discord";
          after = [ "network.target" ];
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            ExecStart = "${pkgs.alertmanager-discord}/bin/alertmanager-discord";
            Restart = "on-failure";
            RestartSec = 5;
            EnvironmentFile = "${cfg.webhookFile}";
            DynamicUser = true;
            PrivateTmp = true;
            NoNewPrivileges = true;
          };
          environment = {
            LISTEN_ADDRESS = cfg.address;
          };
          unitConfig = {
            StartLimitIntervalSec = 0;
          };
        };
      })
  ];
}
