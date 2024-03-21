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

  # So we don't listen on the GitLab SSH port
  services.openssh.listenAddresses = [
    { addr = ipv4.address; port = 22; }
    { addr = ipv6.address; port = 22; }
  ];

  time.timeZone = "Europe/Helsinki";

  networking.defaultGateway = { address = ipv4.gateway; interface = networkInterface; };
  networking.defaultGateway6 = { address = ipv6.gateway; interface = networkInterface; };
  networking.nameservers = [ "8.8.8.8" ];
  
  # networking.nftables.enable = true;
  networking.firewall = {
    enable = true;
    # Needs to be disabled or else it breaks ipv6 routing via docker bridges
    checkReversePath = false;
    # NixOS has a really shitty firewall that doesn't work with forwarded traffic
    # well, supposedly it does with the nftables backend but that didn't seem to work either
    # and apparently conflicts with docker, so here we go with the good old manual iptables
    # invocations
    extraCommands = ''
      ip6tables -P FORWARD DROP
      ip6tables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
      ip6tables -A FORWARD -p ipv6-icmp -j ACCEPT
      ip6tables -A FORWARD -i br-matrix -o ${networkInterface} -j ACCEPT
      ip6tables -A FORWARD -i br-kerio -o ${networkInterface} -j ACCEPT
      ip6tables -A FORWARD -i br-traefik -o ${networkInterface} -j ACCEPT
      ip6tables -A FORWARD -i ${networkInterface} -o br-traefik -d 2a01:4f9:3051:104f:8::2 -p tcp -m multiport --dports 80,443 -j ACCEPT
      ip6tables -A FORWARD -i ${networkInterface} -o br-traefik -d 2a01:4f9:3051:104f:8::2 -p udp --dport 443 -j ACCEPT
    '';
  };

  networking.firewall.interfaces.enp7s0.allowedTCPPorts = [ 22 80 443 ];
  networking.firewall.interfaces.enp7s0.allowedUDPPorts = [ 443 ];

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
