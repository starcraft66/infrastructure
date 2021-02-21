{ isDev ? true
, pkgs ? import (builtins.fetchTarball "https://github.com/nixos/nixpkgs/archive/1aa9b59d4c9c4d453fc4ae9663f0a4c788fdd747.tar.gz") { }
}:

with pkgs;
mkShell rec {
  buildInputs = [
    ansible
    kubectl                    # v1.18.1
    kubernetes-helm            # v3.2.1
    terraform_0_14             # v0.12.28
    sops
    kustomize
  ] ++ lib.optional isDev [
    kubectx                    # v0.9.0
    kind                       # v0.8.1
  ];

  KUSTOMIZE_PLUGIN_HOME = pkgs.buildEnv {
    name = "kustomize-plugins";
    paths =  [
      (callPackage ~/src/nixpkgs/pkgs/development/tools/kustomize/kustomize-sops.nix {})
    ];
    postBuild = ''
      mv $out/lib/* $out
      rm -r $out/lib
    '';
    pathsToLink = [ "/lib" ];
  };

  shellHook = let
    concatVersions = x: lib.concatStringsSep "\n" (lib.flatten x);
    mapper = builtins.map (x: if builtins.typeOf x == "list" then concatVersions (mapper x) else x.name);
    versions = mapper buildInputs;
  in ''
    getVersion () {
      echo "${concatVersions versions}"
    }
    getVersion

    if [ -n "$ZSH_VERSION" ]; then
      source <(kubectl completion zsh) 2>/dev/null;
    else
      source <(kubectl completion bash) 2>/dev/null;
    fi

    echo Touch the YubiKey.
    set -a
    eval "$(sops --decrypt --output-type dotenv secrets/terraform-backend.yaml)"
    set +a

    echo Need to package RBAC OIDC shit
  '';
}
