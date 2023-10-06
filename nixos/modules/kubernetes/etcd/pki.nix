{ config, lib, pkgs, ... }:

with pkgs.lib.tdude.vault;
let
  cfg = config.services.tdude.kubernetes.etcd;
in {
  systemd.tmpfiles.rules = lib.mkIf cfg.enable [
    "d /var/lib/secrets/etcd 0700 etcd etcd -"
  ];

  security.sudo.extraRules = lib.mkIf cfg.enable 
    [ (mkRestartServiceSudoersRule "etcd" [ "etcd" ]) ];

  services.vault-agent.instances.etcd = lib.mkIf cfg.enable 
    (mkVaultAgentInstance "etcd" null [
      (mkVaultAgentTemplate "/var/lib/secrets/etcd/server-complete.pem" [ "etcd" ] (mkEtcdServerCertificateTemplate "${config.networking.hostName}.235.tdude.co"))
      (mkVaultAgentTemplate "/var/lib/secrets/etcd/peer-complete.pem" [ "etcd" ] (mkEtcdPeerCertificateTemplate "${config.networking.hostName}.235.tdude.co"))
    ]);

  # give vault-agent some time to render secrets before dependent services
  # start up and blow up because their TLS certificates don't exist yet,
  # causing the activation script to fail
  systemd.services."vault-agent-etcd".serviceConfig.ExecStartPost = lib.mkIf cfg.enable "${pkgs.coreutils}/bin/sleep 5";
}