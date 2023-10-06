{ config, lib, ... }:

let
  cfg = config.services.tdude.kubernetes.etcd;
in {
  services.etcd = {
    enable = lib.mkIf cfg.enable true;
    name = config.networking.hostName;

    advertiseClientUrls = [ "https://${config.networking.hostName}.235.tdude.co:2379" ];
    initialAdvertisePeerUrls = [ "https://${config.networking.hostName}.235.tdude.co:2380" ];
    # TODO: Configure the etcd cluster members based on the colmena nodes
    initialCluster = [
      "sassaflash=https://sassaflash.235.tdude.co:2380"
      "stormfeather=https://stormfeather.235.tdude.co:2380"
    ];
    # This needs to either be new on the first node, or the first node has to already have a data directory
    initialClusterState = "existing";
    listenClientUrls = [ "https://[::]:2379" ];
    listenPeerUrls = [ "https://[::]:2380" ];

    clientCertAuth = true;
    peerClientCertAuth = true;

    certFile = "/var/lib/secrets/etcd/server.pem";
    keyFile = "/var/lib/secrets/etcd/server-key.pem";

    peerCertFile = "/var/lib/secrets/etcd/peer.pem";
    peerKeyFile = "/var/lib/secrets/etcd/peer-key.pem";

    peerTrustedCaFile = "/var/lib/secrets/etcd/etcd-ca.pem";
    trustedCaFile = "/var/lib/secrets/etcd/etcd-ca.pem";
  };

  systemd.services.etcd.after = [ "vault-agent-etcd.service" ];
}