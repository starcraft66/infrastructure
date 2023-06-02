{ config, lib, pkgs, ... }:

{
  boot.loader.grub.enable = lib.mkDefault true;
  boot.initrd.systemd.enable = true;
  boot.initrd.network = {
    enable = true;
    ssh = {
      enable = true;
      port = 2222;
      hostKeys = [
        "/etc/secrets/initrd/ssh_host_rsa_key"
        "/etc/secrets/initrd/ssh_host_ed25519_key"
      ];
    };
  };
}