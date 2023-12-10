{ config, lib, pkgs, ... }:

{
  services.tor = {
    enable = true;
    enableGeoIP = false;
    relay.onionServices = {
      shitstain = {
        version = 3;
        map = [{
          port = 80;
          target = {
            addr = "[::1]";
            port = 8080;
          };
        }];
      };
    };
    settings = {
      ClientUseIPv4 = false;
      ClientUseIPv6 = true;
      ClientPreferIPv6ORPort = true;
    };
  };
}