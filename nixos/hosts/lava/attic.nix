{ ... }:
{
  services.nginx = {
    enable = true;
    virtualHosts."nixcache.tdude.co" = {
      listenAddresses = [ "[2a01:4f9:3051:104f::2]" ];
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://[::1]:58345";
        proxyWebsockets = true;
      };
    };
  };

  services.atticd = {
    enable = true;

    # Replace with absolute path to your credentials file
    credentialsFile = "/var/lib/secrets/atticd";

    settings = {
      listen = "[::1]:58345";
      
      storage = {
        type = "s3";
        bucket = "tdude-nix-cache";
        region = "us-west-000";
        endpoint = "https://s3.us-west-000.backblazeb2.com";
      };

      # Data chunking
      #
      # Warning: If you change any of the values here, it will be
      # difficult to reuse existing chunks for newly-uploaded NARs
      # since the cutpoints will be different. As a result, the
      # deduplication ratio will suffer for a while after the change.
      chunking = {
        # The minimum NAR size to trigger chunking
        #
        # If 0, chunking is disabled entirely for newly-uploaded NARs.
        # If 1, all NARs are chunked.
        nar-size-threshold = 64 * 1024; # 64 KiB

        # The preferred minimum size of a chunk, in bytes
        min-size = 16 * 1024; # 16 KiB

        # The preferred average size of a chunk, in bytes
        avg-size = 64 * 1024; # 64 KiB

        # The preferred maximum size of a chunk, in bytes
        max-size = 256 * 1024; # 256 KiB
      };
    };
  };
}