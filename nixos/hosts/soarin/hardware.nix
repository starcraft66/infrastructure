{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  # hpsa is important to see the P420i's logical volume
  # tg3, mlx4_en and mlx4_core are used for initrd networking
  boot.initrd.availableKernelModules = [ "tg3" "mlx4_core" "mlx4_en" "hpsa" "ehci_pci" "ahci" "uhci_hcd" "hpsa" "usbhid" "usb_storage" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ "mlx4_core" "mlx4_en" "tg3" "8021q" ];
  boot.kernelModules = [ "kvm-intel" "dummy" ];
  boot.extraModulePackages = [ ];

  # Fix HP iLO4 console breakage
  boot.kernelParams = [ "intel_iommu=igfx_off" "intremap=off" ];

  boot.loader.grub.device = "/dev/disk/by-id/wwn-0x600508b1001c162a37be8e75ee3432c0";

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/fe7f0696-2979-4fba-9347-5380ea2f1f43";
      fsType = "btrfs";
      options = [ "subvol=root" "noatime" ];
    };

  boot.initrd.luks.devices."root".device = "/dev/disk/by-uuid/e3e14e0b-8bb1-4a15-8b94-d84a476472ce";
  boot.initrd.luks.devices."swap".device = "/dev/disk/by-uuid/9c87d2ad-6a73-434c-afdf-36c223bc5c85";

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/fe7f0696-2979-4fba-9347-5380ea2f1f43";
      fsType = "btrfs";
      options = [ "subvol=nix" "noatime" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/8fb477f7-5513-4043-a3b8-2627924a19be";
      fsType = "ext4";
    };

  # No swap on kubernetes
  swapDevices = [];
    # [ { device = "/dev/disk/by-uuid/5b862349-e062-47d5-a651-8bd996c82901"; }
    # ];

  networking.useDHCP = lib.mkDefault false;
  networking.useNetworkd = lib.mkDefault true;

  # Disable SLAAC
  boot.kernel.sysctl = {
    "net.ipv6.conf.eno3/29.autoconf" = 0;
    # "net.ipv6.conf.eno3.accept_ra" = 0;
  };

  # Temporary hack to make VLANs create during stage 1
  # initrd networking
  # TODO: upstream the fix
  boot.initrd.systemd.network.networks."40-eno3".vlan = config.systemd.network.networks."40-eno3".vlan;
  # Same deal here
  boot.initrd.systemd.network.netdevs = config.systemd.network.netdevs;

  networking.vlans = { 
    "eno3.28" = { id = 28; interface = "eno3"; };
    "eno3.29" = { id = 29; interface = "eno3"; };
  };

  systemd.network.netdevs.dummy0.netdevConfig = {
    Kind = "dummy";
    Name = "dummy0";
  };

  networking.interfaces."eno3.29" = let 
    ip = "172.16.29.22";
    gateway = "172.16.29.1";
  in {
    tempAddress = "disabled";
    ipv4.addresses = [ { address = ip; prefixLength = 24; } ];
    ipv4.routes = [
      # Default route
      {
        address = "0.0.0.0";
        prefixLength = 0;
        via = gateway;
        options.src = ip;
        options.onlink = "";
      }
    ];
    ipv6.addresses = [ { address = "2a10:4741:36:29::7"; prefixLength = 64; } ];
    # v6 default route assigned via slaac
  };

  networking.interfaces."eno3.28" = {
    tempAddress = "disabled";
    ipv6.addresses = [ { address = "2a10:4741:36:28::7"; prefixLength = 64; } ];
    # we only care about the implicit /64 for the storage vlan, no default route
    # v6 assigned via slaac
  };

  # further configuration of networking.interfaces.enp10s0 will be needed  

  networking.nameservers = [ "2a10:4741:36:25::1" "172.32.25.1" ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}