{ ... }:

{
  security.acme.acceptTerms = true;
  security.acme.defaults.email = "tristan@tzone.org";
  security.acme.defaults.credentialFiles = {
    CLOUDFLARE_DNS_API_TOKEN_FILE = "/var/lib/secrets/acme/cloudflare-api-token";
  };
}