{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  # hpsa is important to see the P420i's logical volume
  # tg3 and mlx4_core are used for initrd networking
  boot.initrd.availableKernelModules = [ "tg3" "mlx4_core" "hpsa" "ehci_pci" "ahci" "uhci_hcd" "hpsa" "usbhid" "usb_storage" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
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

  networking.interfaces.eno4 = let 
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

  # further configuration of networking.interfaces.enp10s0 will be needed  

  networking.nameservers = [ "2607:fa48:6ed8:8a5d::1" "172.32.25.1" ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}