{ inputs, lib, ... }:

rec {
  system = "x86_64-linux";
  modules = [
    ./configuration.nix
    ./hardware.nix
    ./kubernetes.nix
    ./acme.nix
    inputs.sops-nix.nixosModules.sops
  ];
  nixosInput = inputs.nixos;
  pkgs = import nixosInput {
    inherit system;
    config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "vault-bin" "vault"
    ];
    overlays = builtins.attrValues inputs.self.overlays;
  };
  hostname = "sassaflash.235.tdude.co";
  tags = [ "k8s-235" ];
  magicRollback = false; # set to false when changing net config
  format = "install-iso";
}
