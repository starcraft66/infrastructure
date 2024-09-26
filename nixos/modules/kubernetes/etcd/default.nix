{ config, pkgs, lib, ... }:

with lib;
{
  imports = [
    ./pki.nix
    ./etcd.nix
  ];

  options.services.tdude.kubernetes.etcd = {
    enable = options.mkEnableOption "Enable the kubernetes etcd role";
    initialClusterPeers = mkOption {
      type = types.attrsOf (types.submodule {
        options = {
          hostname = mkOption {
            type = types.str;
            description = "Hostname of the etcd peer";
          };
        };
      });
      description = "List of initial etcd cluster peers";
      default = {};
    };
    # The initial cluster state of the etcd cluster, must be either 'new' or 'existing'. Validate this
    initialClusterState = mkOption {
      type = types.str;
      default = "existing";
      description = "The initial cluster state of the etcd cluster";
    };
  };
}
