{ inputs, ... }:

rec {
  system = "x86_64-linux";
  modules = [
    ./configuration.nix
    ./hardware.nix
    ./websites.nix
    ./hiddenservice.nix
    ./mailserver.nix
    inputs.sops-nix.nixosModules.sops
    inputs.simple-nixos-mailserver.nixosModules.default
  ];
  pkgs = import inputs.nixos {
    inherit system;
    overlays = builtins.attrValues inputs.self.overlays;
  };
  hostname = "stone.tdude.co";
  magicRollback = false; # set to false when changing net config
  format = "install-iso";
}
