{ config, pkgs, ... }:

{
  networking.hostName = "stormfeather";
  networking.domain = "235.tdude.co";
  time.timeZone = "America/Toronto";

  environment.systemPackages = with pkgs; [
    vim
    wget
  ];

  services.openssh.enable = true;

  system.stateVersion = "22.11";
}