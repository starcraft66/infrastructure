{ config, lib, pkgs, ... }:

let
  cfg = config.services.tdude.kubernetes.worker;
in {
  environment.systemPackages = lib.mkIf cfg.enable (with pkgs; [ kubectl ]);
  services.kubernetes.kubelet = lib.mkIf cfg.enable (rec {
    enable = true;
    address = "::";
    # Must resolve to node IP because the apiserver will use this to reach the kubelet
    # using the default preferred address type.
    hostname = config.networking.fqdn;
    unschedulable = false;

    extraOpts = lib.mkIf config.services.resolved.enable
      ''--resolv-conf=/run/systemd/resolve/resolv.conf
      '';

    kubeconfig = rec {
      caFile = "/var/lib/secrets/kubernetes/kubernetes-ca.pem";
      certFile = tlsCertFile;
      keyFile = tlsKeyFile;
      server = "https://${config.networking.hostName}.235.tdude.co:6443";
    };

    clientCaFile = "/var/lib/secrets/kubernetes/kubernetes-ca.pem";
    tlsCertFile = "/var/lib/secrets/kubernetes/worker.pem";
    tlsKeyFile = "/var/lib/secrets/kubernetes/worker-key.pem";
  });

  networking.firewall.allowedTCPPorts = lib.mkIf cfg.enable [
    config.services.kubernetes.kubelet.port
  ];
}