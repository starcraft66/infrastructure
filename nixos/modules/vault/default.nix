{ config, lib, ... }:
with lib;
let
  cfg = config.services.tdude.vault;
in {
  imports = [ ./vault.nix ];

  options.services.tdude.vault = {
    enable = options.mkEnableOption "Enable the vault role";
    raftPeers = options.mkOption {
      type = types.listOf types.str;
      default = [];
      description = "List of raft peer hostnames";
    };
    hostname = options.mkOption {
      type = types.str;
      description = "The hostname vault will be accessed from by clients";
    };
  };
}
