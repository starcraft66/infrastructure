{ lib, pkgs, config, inputs, ... }:
with lib;
let
  cfg = config.common;
  sshKeys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAiR1wVz1/m2KXNWIUy02/yftUz+P7B/ZsPQ34PoiyJ/+SFiZBOpAX5KJhdyXwDY1l631CyzYX/yI/6I78GB6qoZGjrLG6g0lk5k70VBsdN+YadaHKn4SEs7KKmf2yNPkVWnCrXnVIqZV/ixLtwzQAnIY11pr5vpwEJjydDvb1+imtT6hyTGvVR2f3ZtBl0LryAW3RisLq9G6m+dlJtLGPJcwsSzSh+dqO9DocLPHff8gEgXyP8TqDQM8iS4lkHQYNlFs6KcSHp7/JE1RShjMSoOYy2VfrpCRrzds0GYTzuirTYo5DL1s3vQuWH5gEWk1tWht8ObjYGondZ7anz4bgXQ== rsa-key-201401"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDrI5nV45rGWmbU4NjYpyUKMmmPL9JQw+V1Sy+avJxYsqUQkQAd7niZoujNKP56l0Mm1SJPGMIGnyc/711dE1fz//lupNgZnjZbavR6JnklyqwKRvZZja7I8oWBS1Vo6U8ClZvl23yeVl6NZbu97POrgyZm1EljafY1xb7H0GHe55RU9W+I/Fn9hC6CO+15Erv8FwteyqWQqOT3OBqmzttS0Tv3pqucAUFhxG6kNro9N8/KBDmJzdyHMQqv/CzhP9+r+AGkBw4P7/zRhcPTKcXKCkRKWlYFmOkS7ztCY8s+leCJulT427K4riumjHEziQ6WXvZ4Nm0ZIxI2drvb/SbHJSaV5sAIp6QPGLjrRrRH5qkew+jJLIAt+MHiAXYcE5MFG/WdepP4dxcCFDPJV93RLqUDNQfsTLOThJr/8q68qwe6J3ELVMmj+Hg8kMAYSlsnk91jo/6UAO+6uWfYvspjICeFtxYvU+gZ9wXNsUL7e2jEqHC+hfBGq01UHqFPJTwjo7FC31L/EuQDvue5z+qJsuY9uGZzk1jgs/67kvGD5whiuwo6a0F4CHxiwvlJBddYpR1S02gqYv5gsDtZyeYpcnwmhR8oagrgYQ0lkjVTFKQNkrxVZHcjbsL5krLRyXZVRISOxxekLO566BIaBT6zUujBwmCJ3wtUrI9JAtqd0w== cardno:000609029473"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC8wZwiCGx/LX3xJZ0Yr323Apl43SFG2ETZsCavU06WO1OnybJOrZ6KqYQiO9mmsPjjQYHJApaJPBV2xiuOynfTPrEwZyBl0WqyaicqdczxirIez+ktNM8y/CSQ6XpmhfI/+UtdtHvlikWVEKG6oSQOi+QenXmCnIjZSqMRCOj7x3DD+D7fhIN6I+Ssw6XuPdBzAvDlpJ7vDtL2We7gA2PipX1I7erGsL3CnJzk/7ui9ha7r6Fz4WWwgEMuwx+WUxUuy9kK25SMJWwtzaHbeW3CZoLO0s9Fz4w9Z71hON/j/5xh7ynulFEiuco8zfxW6ySRf1HjlzyUN9GO2OMqqiFs8UCtvLDicv8ooCX1UCUiuEr9TwvAPx2du86bXwKpd0pq0ZZD3ymPxajbPGLLT7FYgzxUXbCpY3OeyD85dJB/JZ+5sMdPyimK26w2abLC9VCOV/+BTf15VjL8qTbby+BQNW1vLPcxauhWXVfhVV8FEVri97fj7wa9z7BIBneiIxjzjkpEWRtR8NhCBczioog81EJAFafWhcLEKBwn05YpN92iLWysBBxefIiBoynkfm+1+Ztu3z351BWxFMBod9DmOE6jf2utD12lCm1KeZ+vhnSfsfsBbhJ7/XfKvZ9ZE3igWhFw3A8FzOuuExKEKQLEgn2gUUa9bfRhdCX7PTeFTw== cardno:000609769932"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCqvCOuh+/tsBgxY8I9lYauzLAQgtHSSPBLgyFzM5W0jOKsf/ijNfIFbFsNHisNLJJKCM/x03uQ6o21RHxv4OlNw/0ivLES+ZEnWpLzcQ5HZwmv95LsQRSCTNJC7R60JJVdWXUHAMuCOTzt7mVICsBSLosAI+Nw0ynlUy0OMAmnbgmQHEzWQYcWXoajS06HliPq3VoQBbgcZxLSoBtK6y3imVCqkYUB+1UzghJpWN5U0GGgqau2PVLjsi7mrGMfttDbXrQ5/0ndeEQVJs/r9RpZ+C4qZtyRqCCRnjFr5dVNRb/7HIXpVd2AEN4rNMiBLXJ4iWWExk0GVq3pKp/YeJcesMrPLQn3s+xwAPJfRB49kdHafWCGMt8yhTxMTahUwsUQeX04Sa1Yk+fehHfsxvEk5mZ8viQH27pbSNGPxfvbvhXiMftai0mvtQwDYvp7xa78Ztfogea9yZk8QpQ/M/3B9HWF7bxTlR9Hx7g2hyMBngvmEzBjEgolDXuu++B3O/pOHUikdC6dteI3gdHMW9Vgs6QR94VTXVng5ioo0Ff3UlB1f7MwkBkny+AMwSTssTq/cDa53m/aekU9REZREwHla1p1lGA6vL7RQHO9p5j4bRJ3mqJbjC4H5o0O3cdUZZBkvzi/0Pwtl+NP7aa5JG3mCP3B/BCPCqq9STl7dVpqmQ== cardno:000606923500"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCxFTnA13izw+opAN3UADYe7nLU8wxjAXkLHlG3mW95dY9T5Gw58nZhCEDl/8Ozl/768P8jtRqUp+Or95YPeF8Uq3zpjs6cB+0hxPiZwU5a9r7+1Bl3yZSwDr9UYkL+Bv+g7fPgyUNAzLQvvU2IpagP4LIj8V1pYJ97RdT5cJceEB3Q4CsMFks/6KW31JfIGaGjwmAgZobJ8h3vZrTg6FyXJxJm+bB3IB+HMEsdX9HS7WCD32tP/hg2ufn27MOINjepdomFWEFUwawLrqQsu7UXuLL53Lp1aD1K1VGH7KLA+pXRTkI8SsgUbrjADU0wbx5HdclTVYgZRyv5MjvXZbduFs8WdWEdDhOWi+vM+K/S9fMVrywQOHj1J6cszyjOy33KZNcuGd1b7KEPThZldbam6hnm7mHtkcuuBXrG0wUMIDCIBEuRQ7hn1QOV2cLLKMEUOEXDMWzmvY0oLGwfZSaebYOT/m8Z5rLnsOGZUXFubKB5iQ5i2wDuwrf8MSTptsvbuKOwIDU6jOe9VIz/Z0PZ561C8a73/AWpomQZ/dF7sZJks1Ecynwq62CO1edjpNoiac61MYAd7akQhuS8xQ45AAX13aczVgUR3tCLxxz3D54cSNuhZNEfQZ16tNfikum6spF3D6x3Ky+Al3RsojJOcqEx3Ega9tteNTl57G+wmw== cardno:000613146991"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDsnJANRZDcM7GyCD8OLiJiksm5U6FyK53NDKf0nYzipI3bf2ux+9D7GqUKLbg8nw2XygSd+sO7VK/ZI5gGp1hBPyVMMljYReIZ5rY4qnidQn0j66SBY7kwLOGm/5Th/9fGjPyAJzkDJyjhF2r2HPxzojgaq3BNwMvNsnE3v401pMnOXlEY1Tz7vk2GBBS4F1aELVkCZGNzA+UGqqczbCPNFvM7Si7hayMsPBn0y0THydohvJr7yMZ/nADk7ZAK7Wpy6JpzGT8uQ0LeLrPdfo7wxf7Jkqb340e7ie1MBDjm5XYumIktH2un3Okdyq3mYBkCuGQd1lVfifsOrQKBAmU+fuQZwP4NbJvEUHEwO0k94o4VK0isHOpHhY+l8BGAGc6kZW6HrnNcMpHgWyxNib/LVfbz3qgOOdxqBv4TDlzXa2AQRplLgIm/eDLktUn8QSAQJ9jr31nd1Ec1lTIGbBVIaR0ZrtZUcFzNZ3L5MqqPP2ggPQGzW25qD+kWecy7zqW29jOX6WLeQwqbzWqNaotbPswYtKaBofp7M34wVh+3GO34lwKi0KQRqiNzbfBPcVf2jy1qqI46t3Z0nUJ4XMo5f2RhV4uSMFWkt+mTlh3HiQ2JcPr+Xec/aa/q8ZcEWJfvlM05HTv/cZCgNAbvTcS2d/6TwaMw14jxtK2WMsPOiw== cardno:000613146981"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC/J+vzZtv/1CQzmHfgLGsLWowvSJRKr23N+NnBNg1l0dT/cPFTeDtr9kggPaHkdc587kziHFcUtkbewR8r4PgH4xMn272OPwd5r+HT1fffcE1SZO05GaxMvbXwrN6duK9EihtTpp/roitiJ/SmUX5S4YW0lzULUZG6sHDtJ7P5gPACdt/eLN50qwRVxq1yrfD2JfsI9hTFwud75HjPUDtPqL7yhfnuJ1xrbtP7Fzqs70eFQCtm7VcHa5b4azUytHBeHlf3OwBVopkiV7PUzH0UKZ+FMX3T19JyVAKPRvkuL4i2foxQthD4m/Wlr4szK2Z2yzXjAthxD2rwqlY+UiRCwWTIus12fSWS4lZWdkpqhRBXCL/fovkBWg9k4jO3Gkdt+CgbA47mcyBt5wRT013n4SPdAoIDxWRwW14T3urUoBUqjMgHlRy3s2i9cyb+dYzmeu8XIJ0YqvIUmXibTST8DOFKF16I5FqzC2SkVIrqwemqpL6Hk4BltWiZuhMu9ObBqjEKLDQ/JKvbHJH+vM2kS2JXWFfD8TUpS7nen7rTVnl2nwbBl2Ca7uchqIdQ+gOF+Mox1ncfUJ6bDAQ/QEyBCxa2u346hfvZ6Pcg1Dp8muXvkD27vLN7qUdYGnOG518gSTH4dAOYe9gaKYwDWMyH1FGNrW3052pNTN4TphEQpw== cardno:16 738 578"
  ];
in {
  options.common = {
    extraSshKeys = mkOption {
      type = types.listOf types.str;
      default = [ ];
    };
  };
  config = {
    boot.tmp.cleanOnBoot = true;
    networking.firewall.allowPing = true;
    networking.firewall.logRefusedConnections = false;
    services.openssh.enable = true;

    programs.zsh.enable = true;
    users.defaultUserShell = pkgs.zsh;

    environment.systemPackages = with pkgs; [
      # for dig
      bind
      inetutils
      vim
      tcpdump
    ];

    # Service Discovery
    services.lldpd.enable = true;
    services.avahi = {
      enable = true;
      nssmdns = true;
      ipv4 = true;
      ipv6 = true;
      publish = {
        enable = true;
        addresses = true;
        workstation = true;
      };
    };

    users.users.root.openssh.authorizedKeys.keys = sshKeys
      ++ cfg.extraSshKeys;

    boot.initrd.network.ssh.authorizedKeys = sshKeys
      ++ cfg.extraSshKeys;

    services.prometheus.exporters.node = {
      enable = true;
      openFirewall = true;
      listenAddress = "[::]";
      enabledCollectors = [ "interrupts" "systemd" "tcpstat" "processes" ];
      port = 9100;
    };

    # services.promtail = {
    #   enable = true;
    #   configuration = {
    #     server = {
    #       http_listen_port = 3031;
    #       grpc_listen_port = 0;
    #     };
    #     positions = {
    #       filename = "/tmp/positions.yaml";
    #     };
    #     clients = [{
    #       url = "http://176.16.2.5:3100/loki/api/v1/push";
    #     }];
    #     scrape_configs = [{
    #       job_name = "journal";
    #       journal = {
    #         max_age = "12h";
    #         labels = {
    #           job = "systemd-journal";
    #           host = config.networking.hostName;
    #         };
    #       };
    #       relabel_configs = [{
    #         source_labels = [ "__journal__systemd_unit" ];
    #         target_label = "unit";
    #       }];
    #     }];
    #   };
    #   # extraFlags
    # };

    nix = {
      package = pkgs.nix;
      extraOptions = ''
        experimental-features = nix-command flakes
        keep-outputs = true
        keep-derivations = true

        # nop out the global flake registry
        flake-registry = ${builtins.toFile "flake-registry" (builtins.toJSON { version = 2; flakes = [ ]; })}
      '';
      # Pin nixpkgs for older Nix tools
      nixPath = [ "nixpkgs=${pkgs.path}" ];
      settings = {
        trusted-users = [ "root" "@wheel" ];
      };
      registry = {
        self.flake = inputs.self;
        nixpkgs.flake = inputs.nixpkgs;
      };
    };
  };
}
