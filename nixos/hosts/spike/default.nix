{ inputs, lib, ... }:

rec {
  system = "x86_64-linux";
  modules = [
    ./acme.nix
    ./configuration.nix
    ./hardware.nix
    ./kubernetes.nix
    inputs.sops-nix.nixosModules.sops
  ];
  nixosInput = inputs.nixos;
  pkgs = import nixosInput {
    inherit system;
    config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "vault-bin" "vault" "nvidia-x11" "nvidia-settings"
    ];
    overlays = builtins.attrValues inputs.self.overlays;
  };
  hostname = "spike.305-1700.tdude.co";
  tags = [ "k8s-305-1700" ];
  magicRollback = false; # set to false when changing net config
  format = "install-iso";
}
