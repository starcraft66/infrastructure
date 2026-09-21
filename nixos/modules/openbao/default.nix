{ config, lib, pkgs, ... }:

let
  cfg = config.services.tdude.openbao;
  netTypes = pkgs.lib.tdude.net.types;
in
{
  imports = [ ./openbao.nix ];

  options.services.tdude.openbao = {
    enable = lib.mkEnableOption "the OpenBao server role";
    raftPeers = lib.mkOption {
      type = lib.types.listOf netTypes.host;
      default = [ ];
      description = "Raft peer hostnames used for retry_join";
    };
    hostname = lib.mkOption {
      type = netTypes.host;
      description = "Hostname through which clients access OpenBao";
    };
  };
}
