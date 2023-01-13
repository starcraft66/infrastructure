with builtins;

map (x: ./. + "/${x}") (
  filter (x: x != "default.nix")
    (attrNames (readDir ./.))
)