{ config, lib, ... }:
let
  cfg = config.services.tdude.kubernetes.control-plane;
in { 
  services.kubernetes.scheduler = {
    enable = lib.mkIf cfg.enable true;
    address = "::";
    kubeconfig = {
      caFile = "/var/lib/secrets/kubernetes/kubernetes-ca.pem";
      certFile = "/var/lib/secrets/kubernetes/kube-scheduler.pem";
      keyFile = "/var/lib/secrets/kubernetes/kube-scheduler-key.pem";
      server = "https://${config.networking.hostName}.235.tdude.co:6443";
    };
  };
}
