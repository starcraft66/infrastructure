{ config, pkgs, lib, ... }:

with lib;
{
  imports = [
    ./pki.nix
    ./etcd.nix
  ];

  options.services.tdude.kubernetes.etcd = {
    enable = options.mkEnableOption "Enable the kubernetes etcd role";
  };
}
