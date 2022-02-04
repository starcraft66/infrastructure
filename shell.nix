{ isDev ? true
, pkgs ? import (builtins.fetchTarball "https://github.com/nixos/nixpkgs/archive/81f05d871faf75d1456df6adec1d2118d787f65c.tar.gz") { }
}:

with pkgs;
mkShell rec {
  buildInputs = [
    ansible_2_9
    kubectl
    kubernetes-helm
    terraform_1
    sops
    kustomize
    kubetail
    krew
    yamllint
    gnupg
  ] ++ lib.optional isDev [
    kubectx
    kind
  ];

  KUSTOMIZE_PLUGIN_HOME = pkgs.buildEnv {
    name = "kustomize-plugins";
    paths =  [
      kustomize-sops
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
