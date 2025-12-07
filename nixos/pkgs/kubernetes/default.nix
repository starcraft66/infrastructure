{ pkgs, ... }:

let
  supportedVersions = [
    { version = "1.27.8"; hash = "sha256-90tmK7OcEeCdKHYN3aWrGrnv+yiVTx62cPllo+IA4PQ="; }
    { version = "1.28.4"; hash = "sha256-aaGcAIyy0hFJGFfOq5FaF0qAlygXcs2WcwgvMe5dkbo="; }
    { version = "1.29.0"; hash = "sha256-CV0MjT/8tcr4bkFH83Lsuw+pyxN0t5KKlrIrAVA//8Q="; }
    { version = "1.29.1"; hash = "sha256-oAlJHbnkSjL/Gc/zAVU4RaP82h17czRyGsxlpdXPZyE="; }
    { version = "1.30.0"; hash = "sha256-7xRRpchjwtV3dGbZ2hN9qj6soAuiF/K7vTY0LzE6Z5w="; }
    { version = "1.30.2"; hash = "sha256-cxWltHCwb01QsIRSieXwYtImrSfvJLBhN3VIJkxOzX8="; }
    { version = "1.31.0"; hash = "sha256-Oy638nIuz2xWVvMGWHUeI4T7eycXIfT+XHp0U7h8G9w="; }
    { version = "1.32.0"; hash = "sha256-VpinMMWvFYpcqDC9f3q/oEqUHRz7thHMs0bKt6AaNms="; }
    { version = "1.33.0"; hash = "sha256-5MlMBsYf8V7BvV6xaeRMVSRaE+TpG8xJkMwVGm/fVdo="; }
    { version = "1.34.0"; hash = "sha256-rKy4X01pX+kovJ8b2JHV0KuzHJ7PYZ08eDEO3GeuPoc="; }
    { version = "1.34.1"; hash = "sha256-18AMfS2OnInTmdr5fLwtuKaeyGQSiAtk29BjuHl6qQA="; }
    { version = "1.34.2"; hash = "sha256-3rQyoGt9zTeF8+PIhA5p+hHY1V5O8CawvKWscf/r9RM="; }
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
