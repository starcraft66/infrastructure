{ config,... }:

{
  sops.secrets.wg-pk-tun-235-gw = { };
  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "2a0c:9a46:636:f0::2/64" ];
      privateKeyFile = config.sops.secrets.wg-pk-tun-235-gw.path;

      peers = [
        { # 235-gw
          allowedIPs = [ "2a0c:9a46:636:f0::/64" ];
          publicKey = "N7ULw84Nz3K8UrnxjruAIAWC4PDARv9l8av02R0Udh8=";
          endpoint = "235-gw.235.tdude.co:51847";
        }
      ];
    };
  };
}