{ config, lib, pkgs, ... }:

let
  # The default NUT password. We're not exposing upsd on the network so this is fine.
  pw = pkgs.writeText "upsmon-password" "fixmepass";
  upssched-cmd = pkgs.writeShellScriptBin "upssched-cmd" ''
    case $1 in 
      onbatt)
        ${pkgs.inetutils}/bin/logger -t upssched-cmd "UPS on battery power, shutting down in 60 seconds"
          ;;
      onbattshutdown)
        ${pkgs.inetutils}/bin/logger -t upssched-cmd "UPS on battery power for 60 seconds, shutting down now"
        ${pkgs.systemd}/bin/shutdown -h now
          ;;
      ups-back-on-power)
        ${pkgs.inetutils}/bin/logger -t upssched-cmd "UPS online, cancelling shutdown"
        ${pkgs.systemd}/bin/shutdown -c
          ;;
      lowbatt)
        ${pkgs.inetutils}/bin/logger -t upssched-cmd "UPS battery low, shutting down now"
        ${pkgs.systemd}/bin/shutdown -h now
          ;;
      *)
        ${pkgs.inetutils}/bin/logger -t upssched-cmd "Unrecognized command: $1"
          ;;
    esac
  '';

  # Shut down after 60 seconds on battery power
  upssched-conf = pkgs.writeText "upssched.conf" ''
    CMDSCRIPT ${upssched-cmd}/bin/upssched-cmd

    PIPEFN /etc/nut/upssched.pipe
    LOCKFN /etc/nut/upssched.lock

    AT ONBATT * EXECUTE onbatt
    AT ONBATT * START-TIMER onbattshutdown 60
    AT ONLINE * CANCEL-TIMER onbattshutdown
    AT ONLINE * EXECUTE ups-back-on-power
    AT LOWBATT * EXECUTE lowbatt
  '';
  cfg = config.services.tdude.ups-235;
in
{
  options.services.tdude.ups-235 = with lib; {
    enable = mkEnableOption "Enable the ups-235 node role";
  };

  config = lib.mkIf cfg.enable {
    power.ups = {
      enable = true;
      mode = "standalone";
      schedulerRules = toString upssched-conf;
      ups.ups = {
        port = "ups.235.tdude.co";
        driver = "snmp-ups";
      };
      users.upsmon.passwordFile = toString pw;
      upsmon = {
        settings.NOTIFYFLAG = [
          [ "ONLINE" "SYSLOG+EXEC" ]
          [ "ONBATT" "SYSLOG+EXEC" ]
          [ "LOWBATT" "SYSLOG+EXEC" ]
          [ "ONLINE" "SYSLOG+EXEC" ]
          [ "COMMBAD" "SYSLOG+EXEC" ]
          [ "COMMOK" "SYSLOG+EXEC" ]
          [ "REPLBATT" "SYSLOG+EXEC" ]
          [ "NOCOMM" "SYSLOG+EXEC" ]
          [ "FSD" "SYSLOG+EXEC" ]
          [ "SHUTDOWN" "SYSLOG+EXEC" ]
        ];
        monitor.ups = {
          user = "upsmon";
          passwordFile = toString pw;
          system = "ups";
        };
      };
    };
  };
}