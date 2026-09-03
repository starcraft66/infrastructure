with builtins;

[({ lib, ... }: {
  boot.zfs.forceImportRoot = lib.mkForce false;
})]
++
map (x: ./. + "/${x}") (
  filter (x: x != "default.nix")
    (attrNames (readDir ./.))
)
