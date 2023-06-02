{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  # hpsa is important to see the P420i's logical volume
  # tg3, mlx4_en and mlx4_core are used for initrd networking
  boot.initrd.availableKernelModules = [ "tg3" "mlx4_core" "mlx4_en" "hpsa" "ehci_pci" "ahci" "uhci_hcd" "hpsa" "usbhid" "usb_storage" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ "mlx4_core" "mlx4_en" "tg3" "8021q" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  boot.loader.grub.device = "/dev/disk/by-id/wwn-0x600508b1001ceaf6d8bc4ff84ae9347d";

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/50fcd833-2e02-4412-adf6-1a4faf4d4799";
      fsType = "btrfs";
      options = [ "subvol=root" "noatime" ];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/50fcd833-2e02-4412-adf6-1a4faf4d4799";
      fsType = "btrfs";
      options = [ "subvol=nix" "noatime" ];
    };

  boot.initrd.luks.devices."root".device = "/dev/disk/by-uuid/e1f30c8e-6206-4389-9823-e5cc6d04ce79";
  boot.initrd.luks.devices."swap".device = "/dev/disk/by-uuid/8960775a-436b-462a-bef2-2ff29301d5aa";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/b7b355c4-1b2b-4d9b-84f2-0c3db09037a2";
      fsType = "ext4";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/dce4f7f9-036f-4075-8884-aa0b3c8dd22b"; }
    ];

  networking.useDHCP = lib.mkDefault false;
  networking.useNetworkd = lib.mkDefault true;

  # Disable SLAAC on the native vlan
  # The switch port has its native vlan set to 29
  # So that initrd networking which doesn't support
  # vlan configuration afaik can work.
  # boot.kernel.sysctl = {
  #   "net.ipv6.conf.eno1.autoconf" = 0;
  #   "net.ipv6.conf.eno1.accept_ra" = 0; 
  # };

  # Temporary hack to make VLANs create during stage 1
  # initrd networking
  # TODO: upstream the fix
  boot.initrd.systemd.network.networks."40-eno1".vlan = config.systemd.network.networks."40-eno1".vlan;
  # Same deal here
  boot.initrd.systemd.network.netdevs = config.systemd.network.netdevs;

  networking.vlans = { 
    "eno1.28" = { id = 28; interface = "eno1"; };
    "eno1.29" = { id = 29; interface = "eno1"; };
  };

  networking.interfaces."eno1.29" = let 
    ip = "172.16.29.20";
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
    # v6 assigned via slaac
  };

  networking.interfaces."eno1.28" = {
    tempAddress = "disabled";
    # v6 assigned via slaac
  };

  # further configuration of networking.interfaces.enp10s0 will be needed  

  networking.nameservers = [ "2a10:4741:36:25::1" "172.32.25.1" ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}