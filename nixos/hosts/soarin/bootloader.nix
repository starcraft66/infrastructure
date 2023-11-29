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
        # mkdir -p /etc/secrets/initrd
        # ssh-keygen -t rsa -N "" -f /etc/secrets/initrd/ssh_host_rsa_key
        # ssh-keygen -t ed25519 -N "" -f /etc/secrets/initrd/ssh_host_ed25519_key
        "/etc/secrets/initrd/ssh_host_rsa_key"
        "/etc/secrets/initrd/ssh_host_ed25519_key"
      ];
    };
  };
}