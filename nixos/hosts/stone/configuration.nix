{ config, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/profiles/headless.nix")
  ];

  sops.defaultSopsFile = ../../../secrets/stone.yaml;

  networking.hostName = "stone";
  networking.domain = "tdude.co";
  time.timeZone = "America/Toronto";

  environment.systemPackages = with pkgs; [
    vim
    wget
  ];

  users.users.tristan = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [ 
    ];
    openssh.authorizedKeys.keys = config.users.users.root.openssh.authorizedKeys.keys;
  };

  services.openssh.enable = true;

  system.stateVersion = "23.11";
}