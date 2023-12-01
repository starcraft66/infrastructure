{ config, lib, ... }:

let
  cfg = config.services.tdude.kubernetes.worker;
in {
  services.kubernetes.proxy = lib.mkIf cfg.kube-proxy.enable {
    enable = true;
    bindAddress = "::";
    hostname = "${config.networking.hostName}.235.tdude.co";
    kubeconfig = {
      caFile = "/var/lib/secrets/kubernetes/kubernetes-ca.pem";
      certFile = "/var/lib/secrets/kubernetes/kube-proxy.pem";
      keyFile = "/var/lib/secrets/kubernetes/kube-proxy-key.pem";
      server = "https://${config.networking.hostName}.235.tdude.co:6443";
    };
  };
}