{ pkgs, ... }:

let
  supportedVersions = [
    "1.23.0"
    "1.23.1"
    "1.23.2"
    "1.23.3"
    "1.23.4"
    "1.23.5"
    "1.23.6"
    "1.23.7"
    "1.23.8"
    "1.23.9"
    "1.23.10"
    "1.23.11"
    "1.23.12"
    "1.23.13"
    "1.23.14"
    "1.23.15"
    "1.23.16"

    "1.24.0"
    "1.24.1"
    "1.24.2"
    "1.24.3"
    "1.24.4"
    "1.24.5"
    "1.24.6"
    "1.24.7"
    "1.24.8"
    "1.24.9"
    "1.24.10"

    "1.25.0"
    "1.25.1"
    "1.25.2"
    "1.25.3"
    "1.25.4"
    "1.25.5"
    "1.25.6"

    "1.26.0"
    "1.26.1"
  ];
in {
  mkKubernetesPackages = pkgs.lib.genAttrs (map
    (version: "kubernetes_" + (builtins.replaceStrings [ "." ] [ "_" ] version))
    supportedVersions) (version:
      pkgs.callPackage ./kubernetes.nix {
        version = builtins.replaceStrings [ "kubernetes_" "_" ] [ "" "." ] version;
      });
}
