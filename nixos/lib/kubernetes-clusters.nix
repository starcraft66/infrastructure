{ libnet }:

let
  addressAt = offset: cidrString:
    let
      cidr = libnet.cidr.parse cidrString;
      network = libnet.cidr.network cidr;
      address =
        if libnet.cidr.isIpv4 cidr then
          libnet.ipv4.add offset network
        else
          libnet.ipv6.add offset network;
    in
    if libnet.cidr.contains cidr address then
      libnet.ip.toString address
    else
      throw "cluster address offset ${toString offset} is outside ${cidrString}";

  mkCluster =
    { clusterName
    , domain
    , memberNames
    , podCidrs
    , serviceCidrs
    , lanCidrs
    , oidcClientId
    , initialClusterState
    , patroniSynchronousMode
    ,
    }:
    let
      podIpv4 = libnet.cidr.parse podCidrs.ipv4;
      podIpv6 = libnet.cidr.parse podCidrs.ipv6;
      serviceIpv4 = libnet.cidr.parse serviceCidrs.ipv4;
      serviceIpv6 = libnet.cidr.parse serviceCidrs.ipv6;
      lanIpv4 = libnet.cidr.parse lanCidrs.ipv4;
      lanIpv6 = libnet.cidr.parse lanCidrs.ipv6;
      memberFqdns = builtins.listToAttrs (
        map
          (name: {
            inherit name;
            value = "${name}.${domain}";
          })
          memberNames
      );
      vipAt = ipv4Slot: ipv6Slot: {
        ipv4 = addressAt ipv4Slot lanCidrs.ipv4;
        ipv6 = addressAt (ipv6Slot * 65536 + 1) lanCidrs.ipv6;
      };
    in
    assert memberNames != [ ];
    assert libnet.cidr.isIpv4 podIpv4 && libnet.cidr.isIpv6 podIpv6;
    assert libnet.cidr.isIpv4 serviceIpv4 && libnet.cidr.isIpv6 serviceIpv6;
    assert libnet.cidr.isIpv4 lanIpv4 && libnet.cidr.isIpv6 lanIpv6;
    assert !(libnet.cidr.overlaps podIpv4 serviceIpv4);
    assert !(libnet.cidr.overlaps podIpv6 serviceIpv6);
    {
      inherit
        clusterName
        domain
        initialClusterState
        lanCidrs
        memberFqdns
        oidcClientId
        patroniSynchronousMode
        podCidrs
        serviceCidrs
        ;

      apiServiceIps = {
        ipv4 = addressAt 1 serviceCidrs.ipv4;
        ipv6 = addressAt 1 serviceCidrs.ipv6;
      };
      corednsServiceIps = {
        ipv4 = addressAt 2 serviceCidrs.ipv4;
        ipv6 = addressAt 2 serviceCidrs.ipv6;
      };
      domains = {
        kubernetes = "k8s.${domain}";
        pocketId = "id.${domain}";
        vault = "vault.${domain}";
      };
      vips = {
        kubernetes = vipAt 8 8;
        vault = vipAt 9 9;
        # The existing IPv6 VIP hextets are hexadecimal 0x10 and 0x11.
        postgres = vipAt 10 16;
        pocketId = vipAt 11 17;
      };
    };
in
{
  k8s-235-1 = mkCluster {
    clusterName = "k8s-235-1";
    domain = "235.tdude.co";
    memberNames = [ "soarin" "stormfeather" "sassaflash" ];
    podCidrs = {
      ipv4 = "10.234.128.0/18";
      ipv6 = "2a10:4741:36:32:2::/104";
    };
    serviceCidrs = {
      ipv4 = "10.234.64.0/18";
      ipv6 = "2a10:4741:36:32:1::/112";
    };
    lanCidrs = {
      ipv4 = "172.16.29.0/24";
      ipv6 = "2a10:4741:36:29::/64";
    };
    oidcClientId = "3520afd0-0fa5-495f-a5d8-525d5bb913b5";
    initialClusterState = "existing";
    patroniSynchronousMode = true;
  };

  k8s-305-1700-1 = mkCluster {
    clusterName = "k8s-305-1700-1";
    domain = "305-1700.tdude.co";
    memberNames = [ "spike" ];
    podCidrs = {
      ipv4 = "10.235.128.0/18";
      ipv6 = "2a0c:9a46:637:88:2::/104";
    };
    serviceCidrs = {
      ipv4 = "10.235.64.0/18";
      ipv6 = "2a0c:9a46:637:88:1::/112";
    };
    lanCidrs = {
      ipv4 = "172.17.51.0/24";
      ipv6 = "2a0c:9a46:637:51::/64";
    };
    oidcClientId = "648c3180-0c65-4b72-ac17-1da6abf53b9c";
    initialClusterState = "new";
    patroniSynchronousMode = false;
  };
}
