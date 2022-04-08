{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-compat.url = "github:edolstra/flake-compat";
    flake-compat.flake = false;
    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = inputs@{ self, nixpkgs, flake-utils, sops-nix, deploy-rs, ... }: let
    platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" ];
  in {
    overlays.inputs = final: prev: { inherit inputs; };
  } // inputs.flake-utils.lib.eachSystem platforms (system:
    let
      pkgs = import nixpkgs {
        inherit system;
        overlays = builtins.attrValues self.overlays;
      };
      inherit (nixpkgs) lib;
      # Use inputs to avoid infinite recursion
      sops-nix = inputs.sops-nix.packages.${system};
    in {
      # nix run .#minecraft-console -- namespace
      apps = {
        minecraft-console = {
          type = "app";
          program = toString (import ./scripts/minecraft-console.nix { inherit pkgs; }).minecraft-console + "/bin/minecraft-console";
        };
      };

      devShell = pkgs.mkShell {
        name = "infrastructure";

        nativeBuildInputs = [
          sops-nix.sops-import-keys-hook
        ];

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

        # For future usage
        # sopsPGPKeyDirs = [
        #   "./secrets/keys/hosts"
        #   "./secrets/keys/users"
        # ];

        buildInputs = with pkgs; [
          jq
          git
          nixFlakes
          nixfmt
          ansible_2_9
          kubectl
          kubectx
          kubernetes-helm
          terraform_1
          sops
          kustomize
          kubetail
          krew
          yamllint
          gnupg
          sops-nix.ssh-to-pgp
        ];

        shellHook = ''
          if [ -n "$ZSH_VERSION" ]; then
            # Unsupported for now
            :
          else
            source <(kubectl completion bash) 2>/dev/null;
          fi

          echo Touch the YubiKey.
          set -a
          eval "$(sops --decrypt --output-type dotenv secrets/terraform-backend.yaml)"
          set +a
        '';
      };
  });
}
