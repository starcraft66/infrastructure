{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.tdude.vault;
  netTypes = pkgs.lib.tdude.net.types;
in
{
  imports = [ ./vault.nix ];

  options.services.tdude.vault = {
    enable = options.mkEnableOption "Enable the vault role";
    raftPeers = options.mkOption {
      type = types.listOf netTypes.host;
      default = [ ];
      description = "List of raft peer hostnames";
    };
    hostname = options.mkOption {
      type = netTypes.host;
      description = "The hostname vault will be accessed from by clients";
    };
  };
}
