{ config, lib, pkgs, ... }:

let
  cfg = config.services.tdude.kubernetes.worker;
in lib.mkIf cfg.enable {
  environment.systemPackages = with pkgs; [ kubectl ];
  systemd.tmpfiles.rules = [
    "d /var/lib/kubelet/plugins_registry 0700 root root -"
  ];

  # Enable entwork filesystems for PVC mounts
  systemd.services.kubelet.path = with pkgs; [ openiscsi ];
  services.openiscsi = {
    enable = true;
    name = "iqn.2023-01.net.tdude:${config.networking.hostName}";
  };
  boot.kernelModules = [ "nfs" ];
  boot.supportedFilesystems = [ "nfs" ];

  services.kubernetes.dataDir = "/var/lib/kubelet";

  virtualisation.containerd.settings.plugins."io.containerd.grpc.v1.cri".containerd.runtimes.nvidia = lib.mkIf cfg.nvidia.enable {
    runtime_type = "io.containerd.runc.v2";
    runtime_root = "";
    runtime_engine = "";
    privileged_without_host_devices = false;
    options = {
      BinaryName = "${pkgs.nvidia-container-toolkit}/bin/nvidia-container-runtime";
    };
  };

  systemd.services.containerd.path = lib.mkIf cfg.nvidia.enable [ pkgs.libnvidia-container ];
  systemd.services.containerd.serviceConfig = {
    # Applies to all containers spawned
    # More sane than the default 1024 that causes issues with fluentd
    LimitNOFILE = 65536;
  };

  services.kubernetes.kubelet = rec {
    enable = true;
    address = "::";
    # Must resolve to node IP because the apiserver will use this to reach the kubelet
    # using the default preferred address type.
    hostname = config.networking.fqdn;
    unschedulable = false;

    nodeIp = lib.mkIf (cfg.nodeIps != []) (lib.concatStringsSep "," cfg.nodeIps);

    extraOpts =
      ''--cluster-dns=${lib.concatStringsSep "," cfg.dnsResolvers} \
        ${lib.optionalString config.services.resolved.enable "--resolv-conf=/run/systemd/resolve/resolv.conf"}
      '';

    kubeconfig = rec {
      caFile = "/var/lib/secrets/kubernetes/kubernetes-ca.pem";
      certFile = tlsCertFile;
      keyFile = tlsKeyFile;
      server = "https://${config.networking.hostName}.${config.networking.domain}:6443";
    };

    clientCaFile = "/var/lib/secrets/kubernetes/kubernetes-ca.pem";
    tlsCertFile = "/var/lib/secrets/kubernetes/worker.pem";
    tlsKeyFile = "/var/lib/secrets/kubernetes/worker-key.pem";
  };

  networking.firewall.allowedTCPPorts = [
    config.services.kubernetes.kubelet.port
  ];
}