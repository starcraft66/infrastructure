{ config, lib, ... }:
let
  cfg = config.services.tdude.kubernetes.control-plane;
in { 
  services.kubernetes.scheduler = {
    enable = lib.mkIf cfg.enable true;
    address = "::";
    extraOpts = ''
      --authorization-kubeconfig=${config.services.kubernetes.lib.mkKubeConfig "kube-scheduler" config.services.kubernetes.scheduler.kubeconfig} \
      --authentication-kubeconfig=${config.services.kubernetes.lib.mkKubeConfig "kube-scheduler" config.services.kubernetes.scheduler.kubeconfig}
    '';
    kubeconfig = {
      caFile = "/var/lib/secrets/kubernetes/kubernetes-ca.pem";
      certFile = "/var/lib/secrets/kubernetes/kube-scheduler.pem";
      keyFile = "/var/lib/secrets/kubernetes/kube-scheduler-key.pem";
      server = "https://${config.networking.hostName}.${config.networking.domain}:6443";
    };
  };
}
