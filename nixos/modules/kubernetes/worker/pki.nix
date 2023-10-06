{ config, pkgs, lib, ... }:

with pkgs.lib.tdude.vault;
let
  cfg = config.services.tdude.kubernetes.worker;
in {
  systemd.tmpfiles.rules = lib.mkIf cfg.enable [
    "d /var/lib/secrets/kubernetes 0700 kubernetes kubernetes -"
    "d /var/lib/secrets/coredns 0700 coredns coredns -"
  ];

  security.sudo.extraRules = lib.mkIf cfg.enable [
    (mkRestartServiceSudoersRule "kubernetes" [ "kube-proxy" "kubelet" ])
    (mkRestartServiceSudoersRule "coredns" [ "coredns" ])
  ];

  services.vault-agent.instances.kubernetes-worker = lib.mkIf cfg.enable
    (mkVaultAgentInstance "kubernetes" "control-plane" [
      (mkVaultAgentTemplate "/var/lib/secrets/kubernetes/kube-proxy-complete.pem" [ "kube-proxy" ]
        (mkKubernetesCertificateTemplate "kube-proxy" {
          pkiRole = "client-system:node-proxier";
          commonName = "system:kube-proxy";
          altNames = [ ];
          ipSans = [ ];
        }))
      (mkVaultAgentTemplate "/var/lib/secrets/kubernetes/worker-complete.pem" [ "kubelet" ]
        (mkKubernetesCertificateTemplate "worker" {
          pkiRole = "peer-system:nodes";
          # The part after system:node: must match services.kubernetes.kubelet.hostname
          commonName = "system:node:${config.networking.fqdn}";
          altNames = [ config.networking.hostName config.networking.fqdn ];
          inherit (cfg) ipSans;
        }))
    ]);

  services.vault-agent.instances.coredns = lib.mkIf cfg.enable
    (mkVaultAgentInstance "coredns" null [
      (mkVaultAgentTemplate "/var/lib/secrets/coredns/coredns-complete.pem" [ "coredns" ]
        (mkKubernetesCertificateTemplate "coredns" {
          pkiRole = "client";
          commonName = "system:coredns";
          altNames = [ ];
          ipSans = [ ];
        }))
    ]);

  systemd.services."vault-agent-kubernetes-worker".serviceConfig.ExecStartPost = lib.mkIf cfg.enable "${pkgs.coreutils}/bin/sleep 5";
  systemd.services."vault-agent-coredns".serviceConfig.ExecStartPost = lib.mkIf cfg.enable "${pkgs.coreutils}/bin/sleep 5";
}