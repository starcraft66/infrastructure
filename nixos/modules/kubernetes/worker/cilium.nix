{ pkgs, config, lib, ... }:

let
  cfg = config.services.tdude.kubernetes.worker;
in lib.mkIf cfg.enable {
  environment.systemPackages = with pkgs; [ cilium-cli ];
  services.kubernetes.kubelet.cni.packages = with pkgs; [ cni-plugin-cilium ];
  services.kubernetes.kubelet.cni.config = [{
    name = "cilium";
    type = "cilium-cni";
    cniVersion = "0.3.1";
  }];
  networking = {
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
  boot.kernelModules = [ "ip6_tables" "ip6table_mangle" "ip6table_raw" "ip6table_filter" ];
}
