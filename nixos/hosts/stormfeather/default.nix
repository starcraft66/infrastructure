{ inputs, lib, ... }:

rec {
  system = "x86_64-linux";
  modules = [
    ./configuration.nix
    ./hardware.nix
    ./vault.nix
    ./kubernetes.nix
    ./guigz-backup.nix
    inputs.sops-nix.nixosModules.sops
  ];
  pkgs = import inputs.nixos {
    inherit system;
    config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "vault-bin"
    ];
    overlays = builtins.attrValues inputs.self.overlays;
  };
  hostname = "stormfeather.235.tdude.co";
  magicRollback = false; # set to false when changing net config
  format = "install-iso";
}
