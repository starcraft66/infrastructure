{ config, lib, pkgs, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.systemd.enable = true;
  boot.initrd.network = {
    enable = true;
    ssh = {
      enable = true;
      # To prevent ssh clients from freaking out because a different host key is used,
      # a different port for ssh is useful (assuming the same host has also a regular sshd running)
      port = 2222;
      # hostKeys paths must be unquoted strings, otherwise you'll run into issues
      # with boot.initrd.secrets the keys are copied to initrd from the path specified;
      # multiple keys can be set you can generate any number of host keys using
      # `ssh-keygen -t ed25519 -N "" -f /boot/initrd-ssh-key`
      hostKeys = [
        "/boot/initrd-ssh-key"
      ];
    };
  };
}