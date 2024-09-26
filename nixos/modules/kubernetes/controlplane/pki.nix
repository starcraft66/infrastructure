{ config, lib, pkgs, ... }:

with pkgs.lib.tdude.vault;
let
  cfg = config.services.tdude.kubernetes.control-plane;
  lbCfg = config.services.tdude.kubernetes.loadbalancer;
in {
  systemd.tmpfiles.rules = lib.mkIf cfg.enable [
    "d /var/lib/secrets/kubernetes 0700 kubernetes kubernetes -"
  ];

  security.sudo.extraRules = lib.mkIf cfg.enable 
    [ (mkRestartServiceSudoersRule "kubernetes" [ "kube-apiserver" "kube-controller-manager" "kube-scheduler" ]) ];

  services.vault-agent.instances.kubernetes-control-plane = lib.mkIf cfg.enable
    (mkVaultAgentInstance "kubernetes" "control-plane" [
      (mkVaultAgentTemplate "/var/lib/secrets/kubernetes/server-complete.pem" [ "kube-apiserver" ]
        (mkKubernetesCertificateTemplate "apiserver" {
          pkiRole = "server";
          commonName = "${config.networking.hostName}.${config.networking.domain}";
          altNames = [ "kubernetes" "kubernetes.default" "kubernetes.default.svc" "kubernetes.default.svc.cluster" "kubernetes.svc.cluster.local" ] ++ cfg.additionalApiserverAltNames;
          ipSans = cfg.ipSans ++ lib.optionals lbCfg.enable [ lbCfg.k8sIpv4Address lbCfg.k8sIpv6Address ];
        }))
      (mkVaultAgentTemplate "/var/lib/secrets/kubernetes/kubelet-client-complete.pem" [ "kube-apiserver" ]
        (mkKubernetesCertificateTemplate "kubelet-client" {
          pkiRole = "server-system:masters";
          commonName = "kube-api-server";
          altNames = [ ];
          ipSans = [ ];
        }))
      (mkVaultAgentTemplate "/var/lib/secrets/kubernetes/kube-controller-manager-complete.pem" [ "kube-controller-manager" ]
        (mkKubernetesCertificateTemplate "kube-controller-manager" {
          pkiRole = "client-system:kube-controller-manager";
          commonName = "system:kube-controller-manager";
          altNames = [ ];
          ipSans = [ ];
        }))
      (mkVaultAgentTemplate "/var/lib/secrets/kubernetes/admin-complete.pem" [ ]
        (mkKubernetesCertificateTemplate "admin" {
          pkiRole = "client-system:masters";
          commonName = "admin";
          altNames = [ ];
          ipSans = [ ];
        }))
      (mkVaultAgentTemplate "/var/lib/secrets/kubernetes/kube-scheduler-complete.pem" [ "kube-scheduler" ]
        (mkKubernetesCertificateTemplate "kube-scheduler" {
          pkiRole = "client-system:kube-scheduler";
          commonName = "system:kube-scheduler";
          altNames = [ ];
          ipSans = [ ];
        }))
      (mkVaultAgentTemplate "/var/lib/secrets/kubernetes/front-proxy-complete.pem" [ "kube-apiserver" ] (mkFrontProxyClientCertificateTemplate "front-proxy-client"))
      (mkVaultAgentTemplate "/var/lib/secrets/kubernetes/etcd-client-complete.pem" [ "kube-apiserver" ] (mkEtcdClientCertificateTemplate "${config.networking.hostName}.${config.networking.domain}"))
    ]);

  systemd.services."vault-agent-kubernetes-control-plane".serviceConfig.ExecStartPost = lib.mkIf cfg.enable "${pkgs.coreutils}/bin/sleep 5";
}