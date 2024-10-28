{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  # hpsa is important to see the P420i's logical volume
  # tg3, mlx4_en and mlx4_core are used for initrd networking
  boot.initrd.availableKernelModules = [ "tg3" "mlx4_core" "mlx4_en" "hpsa" "ehci_pci" "ahci" "uhci_hcd" "hpsa" "usbhid" "usb_storage" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ "mlx4_core" "mlx4_en" "tg3" "8021q" ];
  boot.kernelModules = [ "kvm-intel" "dummy" "sg" ];
  boot.extraModulePackages = [ ];

  # Fix HP iLO4 console breakage
  boot.kernelParams = [ "intel_iommu=igfx_off" "intremap=off" ];

  boot.loader.grub.device = "/dev/disk/by-id/wwn-0x600508b1001c90aec91c0d2ed102d97a";

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/65ebd98b-6724-47fc-8e72-1700d24b102a";
      fsType = "btrfs";
      options = [ "subvol=root" "noatime" ];
    };

  boot.initrd.luks.devices."root".device = "/dev/disk/by-uuid/d7293287-aadc-465a-836b-960dfe4103ec";
  boot.initrd.luks.devices."swap".device = "/dev/disk/by-uuid/91bdfcbe-dec9-492a-87db-a791f7f45810";

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/65ebd98b-6724-47fc-8e72-1700d24b102a";
      fsType = "btrfs";
      options = [ "subvol=nix" "noatime" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/6b05567c-0dc6-4be9-b0b0-628899ac033b";
      fsType = "ext4";
    };

  # No swap on kubernetes
  swapDevices = [];
    # [ { device = "/dev/disk/by-uuid/8bf7158c-eeab-4213-89a8-479b8a3d12bd"; }
    # ];

  networking.useDHCP = lib.mkDefault false;
  networking.useNetworkd = lib.mkDefault true;

  # Disable SLAAC
  boot.kernel.sysctl = {
    "net.ipv6.conf.enp10s0/29.autoconf" = 0;
    "net.ipv6.conf.enp10s0/29.accept_ra" = 0;
    "net.ipv6.conf.enp10s0/28.autoconf" = 0;
    "net.ipv6.conf.enp10s0/28.accept_ra" = 0;
    "net.ipv6.conf.enp10s0.autoconf" = 0;
    "net.ipv6.conf.enp10s0.accept_ra" = 0;
  };
  systemd.network.networks."40-enp10s0.29".networkConfig.IPv6AcceptRA = "no";
  systemd.network.networks."40-enp10s0.28".networkConfig.IPv6AcceptRA = "no";

  # Temporary hack to make VLANs create during stage 1
  # initrd networking
  # TODO: upstream the fix
  boot.initrd.systemd.network.networks."40-enp10s0".vlan = config.systemd.network.networks."40-enp10s0".vlan;
  # Same deal here
  boot.initrd.systemd.network.netdevs = config.systemd.network.netdevs;

  networking.vlans = {
    "enp10s0.28" = { id = 28; interface = "enp10s0"; };
    "enp10s0.29" = { id = 29; interface = "enp10s0"; };
  };

  systemd.network.netdevs.dummy0.netdevConfig = {
    Kind = "dummy";
    Name = "dummy0";
  };

  networking.interfaces."enp10s0.29" = let
    ip4 = "172.16.29.21";
    gateway4 = "172.16.29.1";
    ip6 = "2a10:4741:36:29::6";
    gateway6 = "2a10:4741:36:29::1";
  in {
    tempAddress = "disabled";
    ipv4.addresses = [ { address = ip4; prefixLength = 24; } ];
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
    ipv6.addresses = [ { address = ip6; prefixLength = 64; } ];
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

  networking.interfaces."enp10s0.28" = {
    tempAddress = "disabled";
    ipv6.addresses = [ { address = "2a10:4741:36:28::6"; prefixLength = 64; } ];
    # we only care about the implicit /64 for the storage vlan, no default route
    # v6 assigned via slaac
  };

  networking.nameservers = [ "2a10:4741:36:25::1" "172.32.25.1" ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}