{ inputs, ... }:

rec {
  system = "x86_64-linux";
  modules = [
    ./configuration.nix
    ./hardware.nix
    ./containers.nix
    ./turn.nix
    inputs.sops-nix.nixosModules.sops
  ];
  nixosInput = inputs.nixos;
  pkgs = import nixosInput {
    inherit system;
    overlays = builtins.attrValues inputs.self.overlays;
  };
  hostname = "lava.tdude.co";
  magicRollback = false; # set to false when changing net config
  format = "kexec-bundle";
}
