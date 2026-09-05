{ pkgs, ... }:

{
  virtualisation = {
    docker = {
      enable = true;
      storageDriver = "zfs";
      enableOnBoot = true;
      daemon.settings = {
        fixed-cidr-v6 = "fd00::/80";
        ipv6 = true;
        ip6tables = false; # We manage iptables rules ourselves since the docker one doesn't work with nftables and seems to conflict with the NixOS firewall
        live-restore = true;
      };
    };
  };

  # Give GitLab CI jobs a persistent dual-stack network. The default Docker
  # bridge predates IPv6 being enabled and is intentionally left unchanged.
  systemd.services.gitlab-ci-docker-network = {
    description = "Create the GitLab CI Docker network";
    wantedBy = [ "multi-user.target" ];
    after = [ "docker.service" ];
    requires = [ "docker.service" ];
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      if ! docker network inspect gitlab-ci >/dev/null 2>&1; then
        docker network create \
          --driver bridge \
          --ipv6 \
          --subnet 10.237.64.0/20 \
          --gateway 10.237.64.1 \
          --subnet 2a01:4f9:3051:104f:10::/80 \
          --gateway 2a01:4f9:3051:104f:10::1 \
          --opt com.docker.network.bridge.name=gitlab-ci0 \
          gitlab-ci
      fi

      test "$(docker network inspect gitlab-ci --format '{{.EnableIPv6}}')" = true
      test -d /sys/class/net/gitlab-ci0
    '';
  };

  systemd.services.ndppd = {
    after = [ "gitlab-ci-docker-network.service" ];
    requires = [ "gitlab-ci-docker-network.service" ];
  };

  # For docker userland proxy gitlab ssh port ipv6
  networking.firewall.interfaces.enp7s0.allowedTCPPorts = [ 80 443 5001 ];

  networking.firewall.trustedInterfaces = [ "docker0" ];

  # interfaces created by podman/docker compose bridges
  services.ndppd = {
    enable = true;
    interface = "enp7s0";
    proxies."enp7s0".rules = {
      "2a01:4f9:3051:104f:7::/80" = {
        method = "iface";
        interface = "br-matrix";
      };
      "2a01:4f9:3051:104f:8::/80" = {
        method = "iface";
        interface = "br-traefik";
      };
      "2a01:4f9:3051:104f:9::/80" = {
        method = "iface";
        interface = "br-kerio";
      };
      "2a01:4f9:3051:104f:10::/80" = {
        method = "iface";
        interface = "gitlab-ci0";
      };
      # "2a01:4f9:3051:104f:1d0::/80" = {
      #   method = "iface";
      #   interface = "wg0";
      # };
      # "2a01:4f9:3051:104f:1d1::/80" = {
      #   method = "iface";
      #   interface = "wg0";
      # };
      # "2a01:4f9:3051:104f:1df::/80" = {
      #   method = "iface";
      #   interface = "wg0";
      # };
    };
  };
}
