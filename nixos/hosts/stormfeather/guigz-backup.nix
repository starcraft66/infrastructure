{ config, lib, pkgs, ... }:

{
  networking.vlans."enp10s0.30" = { id = 30; interface = "enp10s0"; };
  networking.bridges.vmbr0.interfaces = [ "enp10s0.30" ];

  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemu.ovmf.enable = true;
}