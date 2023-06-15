{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-compat.url = "github:edolstra/flake-compat";
    flake-compat.flake = false;
    flake-utils.url = "github:numtide/flake-utils";
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs";
    colmena.url = "github:zhaofengli/colmena";
    colmena.inputs.nixpkgs.follows = "nixpkgs";
    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = inputs@{ self, nixpkgs, flake-utils, sops-nix, deploy-rs, colmena, ... }: let
    platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" ];
  in {
    overlays = {
      inputs = final: prev: { inherit inputs; };
      colmena = colmena.overlays.default;
      deploy-rs = deploy-rs.overlay;
      spos-nix = sops-nix.overlays.default;
      local-packages = self: super: {
        cni-plugin-cilium = super.callPackage ./nixos/pkgs/cni-plugin-cilium.nix {};
      };
    };
  } // inputs.flake-utils.lib.eachSystem platforms (system:
    let
      pkgs = import nixpkgs {
        inherit system;
        overlays = builtins.attrValues self.overlays;
      };
      inherit (nixpkgs) lib;
    in {
      # nix run .#minecraft-console -- namespace
      apps = {
        minecraft-console = {
          type = "app";
          program = toString (import ./scripts/minecraft-console.nix { inherit pkgs; }).minecraft-console + "/bin/minecraft-console";
        };
      };

      devShells.default = pkgs.mkShell {
        name = "infrastructure";

        nativeBuildInputs = with pkgs; [
          sops-import-keys-hook
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
          ansible
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
          ssh-to-pgp
          asciidoctor
          vault
        ] ++ [
          pkgs.colmena
          pkgs.deploy-rs.deploy-rs
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
  }) // (let
      nixosHosts = import ./nixos/hosts { inherit inputs; };
  in {
    inherit (nixosHosts) nixosConfigurations deploy packages colmena;
  });
}
