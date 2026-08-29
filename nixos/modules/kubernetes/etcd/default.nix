{ config, pkgs, lib, ... }:

with lib;
let
  netTypes = pkgs.lib.tdude.net.types;
in
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
            type = netTypes.host;
            description = "Hostname of the etcd peer";
          };
        };
      });
      description = "List of initial etcd cluster peers";
      default = { };
    };
    # The initial cluster state of the etcd cluster, must be either 'new' or 'existing'. Validate this
    initialClusterState = mkOption {
      type = types.str;
      default = "existing";
      description = "The initial cluster state of the etcd cluster";
    };
    pki = {
      vaultURL = mkOption {
        type = netTypes.url;
        description = "The URL of the vault server";
      };
      vaultSNI = mkOption {
        type = netTypes.host;
        description = "The SNI host to use to connect to the vault server";
      };
      clusterName = mkOption {
        type = types.str;
        description = "The name of the kubernetes cluster";
      };
    };
  };
}
