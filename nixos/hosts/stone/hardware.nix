{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot.loader.grub.device = "/dev/sda";
  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "xen_blkfront" "vmw_pvscsi" ];
  boot.initrd.kernelModules = [ "nvme" ];
  fileSystems."/" = { device = "/dev/sda1"; fsType = "ext4"; };

  networking.useDHCP = lib.mkDefault false;
  networking.useNetworkd = lib.mkDefault true;

  networking.interfaces."ens3" = let
    ip4 = "158.69.211.121";
    gateway4 = "158.69.192.1";
    ip6 = "2607:5300:201:3100::7e8c";
    gateway6 = "2607:5300:201:3100::1";
  in {
    tempAddress = "disabled";
    ipv4.addresses = [ { address = ip4; prefixLength = 32; } ];
    ipv4.routes = [
      # Default route
      {
        address = "0.0.0.0";
        prefixLength = 0;
        via = gateway4;
        options.src = ip4;
        options.onlink = "";
      }
    ];
    ipv6.addresses = [ { address = ip6; prefixLength = 128; } ];
    ipv6.routes = [
      # Default route
      {
        address = "::";
        prefixLength = 0;
        via = gateway6;
        options.src = ip6;
        options.onlink = "";
      }
    ];
  };

  # Apparently OVH doesn't have an IPv6 DNS server
  networking.nameservers = [ "213.186.33.99" ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}