# Keep this host configuration covered by the Nix CI evaluation job.
{ config, lib, pkgs, ... }:

{
  sops = {
    defaultSopsFile = ../../../secrets/lava.yaml;
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    secrets = {
      gitlab-runner-registration.mode = "0400";
      attic-ci-token.mode = "0400";
    };
  };

  # Reserve eight of the 5950X's 32 logical CPUs for the rest of the host.
  # `cores` is passed to each derivation; CPUQuota is the aggregate ceiling.
  nix.settings = {
    max-jobs = 4;
    cores = 6;
  };

  systemd.services.nix-daemon.serviceConfig = {
    CPUQuota = "2400%";
    MemoryHigh = "80G";
    MemoryMax = "96G";
    Nice = 10;
    IOWeight = 25;
  };

  services.gitlab-runner = {
    enable = true;
    gracefulTermination = true;
    settings.concurrent = 1;

    services.lava-nix = {
      description = "Lava Nix builder";
      authenticationTokenConfigFile = config.sops.secrets.gitlab-runner-registration.path;

      executor = "docker";
      limit = 1;
      requestConcurrency = 1;
      dockerImage = "nixpkgs/nix";
      dockerPullPolicy = "if-not-present";
      dockerPrivileged = false;
      dockerVolumes = [
        "/nix/store:/nix/store:ro"
        "/nix/var/nix/db:/nix/var/nix/db:ro"
        "/nix/var/nix/daemon-socket:/nix/var/nix/daemon-socket:ro"
        "${config.sops.secrets.attic-ci-token.path}:/run/secrets/attic-ci-token:ro"
        "/cache"
      ];

      environmentVariables = {
        USER = "root";
        NIX_REMOTE = "daemon";
        NIX_CONFIG = "experimental-features = nix-command flakes";
        NIX_SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
        PATH = lib.makeBinPath [
          pkgs.nix
          pkgs.cacert
          pkgs.git
          pkgs.openssh
          pkgs.attic-client
        ] + ":/bin:/sbin:/usr/bin:/usr/sbin";
      };
    };
  };
}
