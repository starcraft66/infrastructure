{ config, lib, pkgs, ... }:

{
  boot.loader.grub.enable = lib.mkDefault true;
  boot.initrd.systemd.enable = true;
}