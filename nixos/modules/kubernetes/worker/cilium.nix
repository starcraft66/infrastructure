{ pkgs, config, lib, ... }:

let
  cfg = config.services.tdude.kubernetes.worker;
in {
  environment.systemPackages = lib.mkIf cfg.enable (with pkgs; [ cilium-cli ]);
  services.kubernetes.kubelet.cni.packages = lib.mkIf cfg.enable [ pkgs.cni-plugin-cilium ];
  services.kubernetes.kubelet.cni.config = lib.mkIf cfg.enable [{
    name = "cilium";
    type = "cilium-cni";
    cniVersion = "0.3.1";
  }];
  networking = lib.mkIf cfg.enable {
    firewall = {
      allowPing = true;
      logReversePathDrops = true;
      checkReversePath = false;
      allowedTCPPorts = [
        4240 # clilum healthcheck
        4244 # hubble api
      ];
      allowedUDPPorts = [
        8472 # clilum vxlan
      ];
    };
  };
  boot.kernelModules = lib.mkIf cfg.enable [ "ip6_tables" "ip6table_mangle" "ip6table_raw" "ip6table_filter" ];
}
