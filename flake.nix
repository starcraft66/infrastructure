{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixos.url = "github:nixos/nixpkgs/nixos-26.05";
    simple-nixos-mailserver.url = "gitlab:simple-nixos-mailserver/nixos-mailserver/nixos-26.05";
    simple-nixos-mailserver.inputs.nixpkgs.follows = "nixos";
    flake-compat.url = "github:edolstra/flake-compat";
    flake-compat.flake = false;
    flake-parts.url = "github:hercules-ci/flake-parts";
    just-flake.url = "github:juspay/just-flake";
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixos";
    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs";
    colmena.url = "github:zhaofengli/colmena";
    colmena.inputs.nixpkgs.follows = "nixpkgs";
    tdude-website.url = "git+https://git.tdude.co/tristan/www.tdude.co.git";
    tdude-website.inputs.nixpkgs.follows = "nixos";
    nix-libnet.url = "github:petohorvath/nix-libnet";
    nix-libnet.flake = false;
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      toplevel@{ inputs
      , inputs'
      , self
      , withSystem
      , ...
      }:
      {
        systems = [
          "x86_64-linux"
          "aarch64-darwin"
          "x86_64-darwin"
        ];

        imports = [
          inputs.flake-parts.flakeModules.easyOverlay
          inputs.just-flake.flakeModule
        ];

        flake = {
          lib.kubernetesClusters = import ./nixos/lib/kubernetes-clusters.nix {
            libnet = import inputs.nix-libnet;
          };

          overlays = {
            inputs = final: prev: { inherit inputs; };
            colmena = inputs.colmena.overlays.default;
            deploy-rs = inputs.deploy-rs.overlays.default;
            spos-nix = inputs.sops-nix.overlays.default;
            lib = final: prev: {
              lib = prev.lib.extend (
                libfinal: libprev:
                  import ./nixos/lib {
                    inherit
                      final
                      inputs
                      prev
                      libfinal
                      libprev
                      ;
                  }
              );
            };
            local-packages = self: super: {
              cni-plugin-cilium = super.callPackage ./nixos/pkgs/cni-plugin-cilium.nix { };
              alertmanager-discord = super.callPackage ./nixos/pkgs/alertmanager-discord.nix { };
            };
          };
        }
        // (
          let
            nixosHosts = import ./nixos/hosts { inherit inputs; };
          in
          {
            inherit (nixosHosts)
              nixosConfigurations
              deploy
              packages
              colmenaHive
              ;
          }
        );

        perSystem =
          moduleArgs@{ config
          , system
          , lib
          , pkgs
          , ...
          }:
          {
            _module.args.pkgs = import inputs.nixpkgs {
              inherit system;
              config.allowUnfree = true;
              overlays = builtins.attrValues (toplevel.config.flake.overlays or [ ]);
            };

            packages = (import ./nixos/pkgs/kubernetes/default.nix { inherit pkgs; }).mkKubernetesPackages;

            # nix run .#minecraft-console -- namespace
            apps = {
              minecraft-console = {
                type = "app";
                program =
                  toString (import ./scripts/minecraft-console.nix { inherit pkgs; }).minecraft-console
                  + "/bin/minecraft-console";
              };
              update-coredns-service-addresses = {
                type = "app";
                program = "${pkgs.writeShellApplication {
                  name = "update-coredns-service-addresses";
                  runtimeInputs = with pkgs; [
                    coreutils
                    git
                    kustomize
                    nix
                    yq-go
                  ];
                  text = ''
                    repo_root="$(git rev-parse --show-toplevel)"
                    addresses="$(mktemp)"
                    trap 'rm -f "$addresses"' EXIT
                    nix eval --json "$repo_root#lib.kubernetesClusters" > "$addresses"

                    update_service() {
                      cluster="$1"
                      service="$2"
                      ipv4="$(yq -p=json -r ".\"$cluster\".corednsServiceIps.ipv4" "$addresses")"
                      ipv6="$(yq -p=json -r ".\"$cluster\".corednsServiceIps.ipv6" "$addresses")"
                      IPV4="$ipv4" IPV6="$ipv6" yq -i \
                        '.spec.clusterIP = strenv(IPV4) | .spec.clusterIPs = [strenv(IPV4), strenv(IPV6)]' \
                        "$repo_root/$service"
                    }

                    update_service k8s-235-1 k8s/apps/coredns/overlays/235-prod/resources/service.yaml
                    update_service k8s-305-1700-1 k8s/apps/coredns/overlays/305-1700-prod/resources/service.yaml
                    kustomize build "$repo_root/k8s/apps/coredns/overlays/235-prod" >/dev/null
                    kustomize build "$repo_root/k8s/apps/coredns/overlays/305-1700-prod" >/dev/null
                  '';
                }}/bin/update-coredns-service-addresses";
              };
            };

            just-flake.features = {
              unlock = {
                enable = true;
                justfile =
                  let
                    expectFDEUnlock = pkgs.writeScript "expect" ''
                      #!${pkgs.expect}/bin/expect -f
                      log_user 0
                      set timeout 10
                      set server [lindex $argv 0]
                      set password [lindex $argv 1]
                      spawn ssh -t -p2222 -lroot $server -- systemctl default
                      expect "🔐 Please enter passphrase for disk"
                      send "$password\n"
                      interact
                    '';
                    expectVaultUnseal = pkgs.writeScript "expect" ''
                      #!${pkgs.expect}/bin/expect -f
                      set timeout 10
                      set server [lindex $argv 0]
                      set password [lindex $argv 1]
                      spawn ssh -t -lroot $server -- vault operator unseal
                      expect "Unseal Key (will be hidden):"
                      send "$password\n"
                      interact
                    '';
                    unlockScript = pkgs.writeScript "unlock" ''
                      #!/usr/bin/env bash
                      set -e
                      read -s -p "Enter password: " password
                      for host in $@; do
                        ${expectFDEUnlock} $host $password
                      done
                    '';
                    unsealScript = pkgs.writeScript "unseal" ''
                      #!/usr/bin/env bash
                      set -e
                      read -s -p "Enter password: " password
                      for host in $@; do
                        ${expectVaultUnseal} $host $password
                      done
                    '';
                  in
                  ''
                    unlock-235:
                      @${unlockScript} stormfeather.235.tdude.co sassaflash.235.tdude.co soarin.235.tdude.co

                    unseal-235:
                      @${unsealScript} stormfeather.235.tdude.co sassaflash.235.tdude.co soarin.235.tdude.co

                    unlock-305-1700:
                      @${unlockScript} spike.305-1700.tdude.co

                    unseal-305-1700:
                      @${unsealScript} spike.305-1700.tdude.co
                  '';
              };
            };

            devShells.default = pkgs.mkShell {
              name = "infrastructure";

              inputsFrom = [
                config.just-flake.outputs.devShell
              ];

              nativeBuildInputs = with pkgs; [
                sops-import-keys-hook
              ];

              VAULT_ADDR = "https://vault.235.tdude.co";

              KUSTOMIZE_PLUGIN_HOME = pkgs.buildEnv {
                name = "kustomize-plugins";
                paths = with pkgs; [
                  kustomize-sops
                ];
                postBuild = ''
                  mv $out/lib/* $out
                  rm -r $out/lib
                '';
                pathsToLink = [ "/lib" ];
              };

              sopsPGPKeyDirs = [
                "./secrets/keys/hosts"
                "./secrets/keys/users"
              ];

              buildInputs = with pkgs; [
                jq
                openssl
                git
                nixpkgs-fmt
                kubectl
                kubectx
                kubernetes-helm
                opentofu
                sops
                kustomize
                kubetail
                yamllint
                gnupg
                ssh-to-pgp
                asciidoctor
                vault
                colmena
                deploy-rs.deploy-rs
                cilium-cli
                hubble
                cfssl
                kubevirt
                kubelogin-oidc
                oci-cli
              ];

              shellHook = ''
                if [ -n "$ZSH_VERSION" ]; then
                  # Unsupported for now
                  :
                else
                  source <(kubectl completion bash) 2>/dev/null;
                fi

                export KUBECONFIG=$(git rev-parse --show-toplevel)/kubeconfig.yaml

                if [[ $(uname -a) == *WSL2* ]]; then
                  # Use windows-side gpg if running in WSL2
                  # to facilitate smartcard usage
                  export SOPS_GPG_EXEC="gpg.exe";
                fi

                echo Touch the YubiKey.
                set -a
                eval "$(sops --decrypt --output-type dotenv secrets/nix-shell.yaml)"
                set +a
              '';
            };
          };
      }
    );
}
