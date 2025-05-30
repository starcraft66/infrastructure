{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.zfs.extraPools = [ "spike" ];

  boot.initrd.availableKernelModules = [ "e1000e" "mlx4_core" "mlx4_en" "ahci" "xhci_pci" "ata_generic" "ehci_pci" "ums_realtek" "usbhid" "usb_storage" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ "e1000e" "mlx4_core" "mlx4_en" ];
  boot.kernelModules = [ "kvm-intel" "dummy" ];
  boot.extraModulePackages = [ ];

  networking.hostId = "387f35ea";

  services.zfs.trim.enable = true;
  services.zfs.autoScrub.enable = true;

  services.xserver.videoDrivers = [ "nvidia" ];

  # Not supported on this GPU
  hardware.nvidia.open = false;
  hardware.nvidia-container-toolkit.enable = true;
  # Very important, needed to expose the GPU driver to containers
  hardware.opengl.enable = true;

  fileSystems."/" =
    { device = "spike/root";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

  fileSystems."/nix" =
    { device = "spike/nix";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

  fileSystems."/var" =
    { device = "spike/var";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

  fileSystems."/var/lib/containerd/io.containerd.snapshotter.v1.zfs" =
    { device = "spike/containerd";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

  fileSystems."/home" =
    { device = "spike/home";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/AB79-7301";
      fsType = "vfat";
    };

  swapDevices =
    [ #{ device = "/dev/disk/by-uuid/95a7d714-2821-407f-ba79-74fa8fd9971d"; randomEncryption = true; }
      #{ device = "/dev/disk/by-uuid/4c623a31-dd9f-4b5e-9c59-2d4f3abe65a3"; randomEncryption = true; }
      #{ device = "/dev/disk/by-uuid/c4ea16ae-c47e-4b17-b681-3660b1b9d60c"; randomEncryption = true; }
      #{ device = "/dev/disk/by-uuid/7155dee7-91dc-4f55-a0ed-c8a9c7934409"; randomEncryption = true; }
      #{ device = "/dev/disk/by-uuid/95803aba-9549-42d9-8b36-e85c9a80fd17"; randomEncryption = true; }
    ];

  networking.useDHCP = lib.mkDefault false;
  networking.useNetworkd = lib.mkDefault true;

  services.fwupd.enable = true;

  # Temporary hack to make VLANs create during stage 1
  # initrd networking
  # TODO: upstream the fix
  boot.initrd.systemd.network.netdevs = config.systemd.network.netdevs;

  # Disable SLAAC, we have a static network configuration
  systemd.network.networks."40-enp8s0".ipv6AcceptRAConfig = { UseAutonomousPrefix = false; };

  systemd.network.netdevs.dummy0.netdevConfig = {
    Kind = "dummy";
    Name = "dummy0";
  };

  networking.interfaces."enp8s0" = let
    ip = "172.17.51.16";
    gateway = "172.17.51.1";
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
    ipv6.addresses = [ { address = "2a0c:9a46:637:51::16"; prefixLength = 64; } ];
    ipv6.routes = [
      # Default route
      {
        address = "::";
        prefixLength = 0;
        via = "2a0c:9a46:637:51::1";
        options.src = "2a0c:9a46:637:51::16";
        options.onlink = "";
      }
    ];
  };

  networking.nameservers = [ "2a0c:9a46:637:51::1" "172.17.51.1" ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}