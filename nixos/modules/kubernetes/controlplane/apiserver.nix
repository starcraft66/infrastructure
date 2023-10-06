{ config, lib, pkgs, ... }:
let
  cfg = config.services.tdude.kubernetes.control-plane;
  corednsPolicies = map
    (r: {
      apiVersion = "abac.authorization.kubernetes.io/v1beta1";
      kind = "Policy";
      spec = {
        user = "system:coredns";
        namespace = "*";
        resource = r;
        readonly = true;
      };
    }) [ "endpoints" "services" "pods" "namespaces" ]
  ++ lib.singleton
    {
      apiVersion = "abac.authorization.kubernetes.io/v1beta1";
      kind = "Policy";
      spec = {
        user = "system:coredns";
        namespace = "*";
        resource = "endpointslices";
        apiGroup = "discovery.k8s.io";
        readonly = true;
      };
    };
in
{
  networking.firewall.allowedTCPPorts = lib.mkIf cfg.enable [ 6443 ];

  environment.systemPackages = lib.mkIf cfg.enable (with pkgs; [ kubectl ]);

  services.kubernetes.apiserver = {
    enable = lib.mkIf cfg.enable true;
    serviceClusterIpRange = lib.concatStringsSep "," [
      cfg.serviceCidrIpv4
      cfg.serviceCidrIpv6
    ];

    # Using ABAC for CoreDNS running outside of k8s
    # is more simple in this case than using kube-addon-manager
    authorizationMode = [ "RBAC" "Node" "ABAC" ];
    authorizationPolicy = corednsPolicies;

    allowPrivileged = true;

    # Not using this for now because the InternalIP of kubelets isn't included in certs right now
    # Setting their hostname to an fqdn for as a band-aid
    # preferredAddressTypes = "InternalDNS,InternalIP,Hostname,ExternalDNS,ExternalIP";

    # advertiseAddress = "https://${config.networking.hostName}.235.tdude.co";

    etcd = {
      servers = [ "https://${config.networking.hostName}.235.tdude.co:2379" ];
      caFile = "/var/lib/secrets/kubernetes/etcd-ca.pem";
      certFile = "/var/lib/secrets/kubernetes/client.pem";
      keyFile = "/var/lib/secrets/kubernetes/client-key.pem";
    };

    clientCaFile = "/var/lib/secrets/kubernetes/kubernetes-ca.pem";

    kubeletClientCaFile = "/var/lib/secrets/kubernetes/kubernetes-ca.pem";
    kubeletClientCertFile = "/var/lib/secrets/kubernetes/kubelet-client.pem";
    kubeletClientKeyFile = "/var/lib/secrets/kubernetes/kubelet-client-key.pem";

    serviceAccountKeyFile = "/var/lib/secrets/kubernetes/service-account.pem";
    serviceAccountSigningKeyFile = "/var/lib/secrets/kubernetes/service-account-key.pem";

    tlsCertFile = "/var/lib/secrets/kubernetes/apiserver.pem";
    tlsKeyFile = "/var/lib/secrets/kubernetes/apiserver-key.pem";
  };

  systemd.services.kube-apiserver.after = [ "vault-agent-kubernetes-control-plane.service" "etcd.service" ];
}
