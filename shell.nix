{ isDev ? true
, pkgs ? import (builtins.fetchTarball "https://github.com/nixos/nixpkgs/archive/95a0e2fc29b850d48d2150492ff7f9158dca4cc0.tar.gz") { }
}:

with pkgs;
mkShell rec {
  KUBECONFIG = toString(./. + "/kubeconfig.yaml");

  buildInputs = [
    ansible
    kubectl                    # v1.18.1
    kubernetes-helm            # v3.2.1
    terraform_0_12             # v0.12.28
  ] ++ lib.optional isDev [
    kubectx                    # v0.9.0
    kind                       # v0.8.1
  ];

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

    echo Need to package RBAC OIDC shit
  '';
}
