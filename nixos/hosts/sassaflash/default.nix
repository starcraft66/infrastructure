{ inputs, ... }:

rec {
  system = "x86_64-linux";
  modules = [
    ./configuration.nix
    ./hardware.nix
    ./vault.nix
    ./kubernetes.nix
    inputs.sops-nix.nixosModules.sops
  ];
  nixosInput = inputs.nixos;
  pkgs = import nixosInput {
    inherit system;
    overlays = builtins.attrValues inputs.self.overlays;
  };
  hostname = "sassaflash.235.tdude.co";
  magicRollback = false; # set to false when changing net config
  format = "install-iso";
}
