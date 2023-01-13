{ config, pkgs, ... }:

{
  boot.loader.grub.enable = lib.mkDefault true;
  boot.loader.grub.version = 2;
  boot.initrd.network = {
    enable = true;
    flushBeforeStage2 = true;
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