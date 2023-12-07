{ pkgs, ... }:

let
  supportedVersions = [
    { version = "1.27.8"; hash = "sha256-90tmK7OcEeCdKHYN3aWrGrnv+yiVTx62cPllo+IA4PQ="; }
    { version = "1.28.4"; hash = "sha256-aaGcAIyy0hFJGFfOq5FaF0qAlygXcs2WcwgvMe5dkbo="; }
    # ... add other versions with their hashes
  ];

  mkKubernetesPackage = version: hash:
    pkgs.callPackage ./kubernetes.nix {
      version = builtins.replaceStrings [ "_" ] [ "." ] version;
      hash = hash;
    };

  packageList = map (attr: {
    name = "kubernetes_" + (builtins.replaceStrings [ "." ] [ "_" ] attr.version);
    value = mkKubernetesPackage attr.version attr.hash;
  }) supportedVersions;
  
in {
  mkKubernetesPackages = builtins.listToAttrs packageList;
}
