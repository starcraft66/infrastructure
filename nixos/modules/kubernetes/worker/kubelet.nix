{ config, lib, pkgs, ... }:

let
  cfg = config.services.tdude.kubernetes.worker;
in {
  environment.systemPackages = lib.mkIf cfg.enable (with pkgs; [ kubectl ]);
  systemd.tmpfiles.rules = lib.mkIf cfg.enable [
    "d /var/lib/kubelet/plugins_registry 0700 root root -"
  ];

  # Enable entwork filesystems for PVC mounts
  systemd.services.kubelet.path = with pkgs; [ openiscsi ];
  services.openiscsi = lib.mkIf cfg.enable {
    enable = true;
    name = "iqn.2023-01.net.tdude:${config.networking.hostName}";
  };
  boot.kernelModules = lib.mkIf cfg.enable  [ "nfs" ];
  boot.supportedFilesystems = lib.mkIf cfg.enable [ "nfs" ];

  services.kubernetes.dataDir = "/var/lib/kubelet";

  services.kubernetes.kubelet = lib.mkIf cfg.enable (rec {
    enable = true;
    address = "::";
    # Must resolve to node IP because the apiserver will use this to reach the kubelet
    # using the default preferred address type.
    hostname = config.networking.fqdn;
    unschedulable = false;

    nodeIp = lib.mkIf (cfg.nodeIps != []) (lib.concatStringsSep "," cfg.nodeIps);

    extraOpts =
      ''--cluster-dns=2a10:4741:36:32:1::2558,10.234.64.2 \
        ${lib.optionalString config.services.resolved.enable "--resolv-conf=/run/systemd/resolve/resolv.conf"}
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