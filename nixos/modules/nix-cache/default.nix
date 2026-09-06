{ lib, ... }:

{
  nix.settings = {
    substituters = lib.mkForce [
      "https://nixcache.tdude.co/ci"
      "https://cache.nixos.org"
    ];
    trusted-public-keys = lib.mkForce [
      "ci:s7iiEVZP2hg/u79D5RWseTjYp/vfqnYwhFpofV1ENP8="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
    netrc-file = "/run/secrets/nix-cache";
  };
}
