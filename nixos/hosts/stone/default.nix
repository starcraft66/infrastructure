{ inputs, ... }:

rec {
  system = "x86_64-linux";
  modules = [
    ./configuration.nix
    ./hardware.nix
    ./websites.nix
    ./hiddenservice.nix
    ./mailserver.nix
    ./headscale.nix
    inputs.sops-nix.nixosModules.sops
    inputs.simple-nixos-mailserver.nixosModules.default
  ];
  nixosInput = inputs.nixos;
  pkgs = import nixosInput {
    inherit system;
    overlays = builtins.attrValues inputs.self.overlays;
  };
  hostname = "stone.tdude.co";
  magicRollback = false; # set to false when changing net config
  format = "install-iso";
}
