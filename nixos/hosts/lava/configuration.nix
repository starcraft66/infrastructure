{ config, pkgs, ... }:
let
  hostName = "lava";
  networkInterface = "enp7s0";
  ipv4 = {
    address = "65.109.116.164";
    gateway = "65.109.116.129";
    netmask = "255.255.255.192";
    prefixLength = 26;
  };
  ipv6 = {
    address = "2a01:4f9:3051:104f::1";
    gateway = "fe80::1";
    prefixLength = 64;
  };
in {
  networking.hostName = hostName;

  # ZFS options from <https://nixos.wiki/wiki/NixOS_on_ZFS>
  networking.hostId = "49e32584";
  boot.supportedFilesystems = [ "zfs" ];

  # Network configuration (Hetzner uses static IP assignments, and we don't use DHCP here)
  networking.useDHCP = false;
  networking.useNetworkd = true;
  networking.interfaces.${networkInterface} = {
    ipv4 = {
      addresses = [
        { address = ipv4.address; prefixLength = ipv4.prefixLength; }
        { address = "65.109.116.168"; prefixLength = 32; } # kerio
      ];
    };
    ipv6 = {
      addresses = [
        { address = ipv6.address; prefixLength = ipv6.prefixLength; }
        { address = "2a01:4f9:3051:104f::3"; prefixLength = 128; } # Gitlab SSH
      ];
    };
  };
  networking.defaultGateway = { address = ipv4.gateway; interface = networkInterface; };
  networking.defaultGateway6 = { address = ipv6.gateway; interface = networkInterface; };
  networking.nameservers = [ "8.8.8.8" ];

  # Remote unlocking, see <https://nixos.wiki/wiki/NixOS_on_ZFS>,
  # section "Unlock encrypted zfs via ssh on boot"
  boot.initrd.availableKernelModules = [ "igb" ];
  boot.kernelParams = [
    # See <https://www.kernel.org/doc/Documentation/filesystems/nfs/nfsroot.txt> for docs on this
    # ip=<client-ip>:<server-ip>:<gw-ip>:<netmask>:<hostname>:<device>:<autoconf>:<dns0-ip>:<dns1-ip>:<ntp0-ip>
    # The server ip refers to the NFS server -- we don't need it.
    "ip=${ipv4.address}::${ipv4.gateway}:${ipv4.netmask}:${hostName}-initrd:${networkInterface}:off:8.8.8.8"
  ];

  # SSH
  services.openssh.enable = true;

  system.stateVersion = "23.11"; # Did you read the comment?
}
