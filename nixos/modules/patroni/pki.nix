{
  config,
  lib,
  pkgs,
  ...
}:

with pkgs.lib.tdude.vault;
let
  pki = config.services.tdude.patroni.pki;
  cfg = config.services.tdude.patroni;
in
{
  systemd.tmpfiles.rules = lib.mkIf cfg.enable [
    "d /var/lib/secrets/patroni 0700 patroni patroni -"
  ];

  security.sudo.extraRules = lib.mkIf cfg.enable [
    (mkRestartServiceSudoersRule "patroni" [ "patroni" ])
  ];

  services.vault-agent.instances.patroni = lib.mkIf cfg.enable (
    mkVaultAgentInstance "patroni" null pki.vaultURL pki.vaultSNI [
      (mkVaultAgentTemplate "/var/lib/secrets/patroni/client-complete.pem" [ "patroni" ] (
        mkEtcdClientCertificateTemplate pki.clusterName "${config.networking.hostName}.${config.networking.domain}"
      ))
    ]
  );

  # Give vault-agent time to render certs before patroni starts
  systemd.services."vault-agent-patroni".serviceConfig.ExecStartPost =
    lib.mkIf cfg.enable "${pkgs.coreutils}/bin/sleep 5";
}
