{ config, pkgs, lib, modulesPath, ... }:

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

  # Disable on internet-facing hosts, leaks information about internal services
  services.avahi.enable = lib.mkForce false;

  services.openssh.enable = true;
  services.prometheus.exporters.node.openFirewall = lib.mkForce false;

  # Clash between redis and nixos-generators vm image
  #  error: The option `boot.kernel.sysctl."vm.overcommit_memory"' is defined multiple times while it's expected to be unique.
  #  Definition values:
  #  - In `/nix/store/1h99qq6970gkx3j0m9w4yrrl9y99y1nk-source/nixos/modules/services/databases/redis.nix': "1"
  #  - In `/nix/store/1h99qq6970gkx3j0m9w4yrrl9y99y1nk-source/nixos/modules/profiles/installation-device.nix': "1"
  #  Use `lib.mkForce value` or `lib.mkDefault value` to change the priority on any of these definitions.
  boot.kernel.sysctl."vm.overcommit_memory" = lib.mkForce "1";

  system.stateVersion = "23.11";
}