{ config,... }:

{
  sops.secrets.wg-pk-tun-235-gw = { };
  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "2a0c:9a46:636:8a5f::32:3/112" ];
      privateKeyFile = config.sops.secrets.wg-pk-tun-235-gw.path;

      peers = [
        { # 235-gw
          allowedIPs = [ "2a0c:9a46:636:8a5f::32:0/112" ];
          publicKey = "CEOeAHqJu8TIU3SetU07W7IE9JMex06+duvQHfm9WQM=";
          endpoint = "235-gw.235.tdude.co:51820";
        }
      ];
    };
  };
}