{ lib, deployment, ... }:

let
  # Set this to true on the first deploy to install vault TLS certificates
  # This is disabled otherwise because it requires a lot of yubikey-confirming
  # due to the sops operations
  deploy-keys = false;
in lib.mkIf deploy-keys {
  deployment.keys."vault-ca.pem" = {
    keyCommand = [ "sops" "-d" "--extract" "[\"ca\"][\"cert\"]" (toString ../../../vault/pki/vault-mtls.yaml) ];

    destDir = "/etc/ssl/certs";
    name = "vault-ca.pem";
    user = "root";
    group = "root";
    permissions = "0644";

    uploadAt = "pre-activation";
  };
  deployment.keys."vault-cert.pem" = {
    keyCommand = [ "sops" "-d" "--extract" "[\"vault\"][\"cert\"]" (toString ../../../vault/pki/vault-mtls.yaml) ];

    destDir = "/var/lib/vault";
    name = "vault-cert.pem";
    user = "vault";
    group = "vault";
    permissions = "0400";

    uploadAt = "pre-activation";
  };
  deployment.keys."vault-key.pem" = {
    keyCommand = [ "sops" "-d" "--extract" "[\"vault\"][\"key\"]" (toString ../../../vault/pki/vault-mtls.yaml) ];

    destDir = "/var/lib/vault";
    name = "vault-key.pem";
    user = "vault";
    group = "vault";
    permissions = "0400";

    uploadAt = "pre-activation";
  };
  deployment.keys."service-account.pem" = {
    keyCommand = [ "sops" "-d" "--extract" "[\"serviceaccount\"][\"pubkey\"]" (toString ../../../vault/pki/serviceaccount.yaml) ];

    destDir = "/var/lib/secrets/kubernetes";
    name = "service-account.pem";
    user = "kubernetes";
    group = "kubernetes";
    permissions = "0400";

    uploadAt = "pre-activation";
  };
  deployment.keys."service-account-key.pem" = {
    keyCommand = [ "sops" "-d" "--extract" "[\"serviceaccount\"][\"privkey\"]" (toString ../../../vault/pki/serviceaccount.yaml) ];

    destDir = "/var/lib/secrets/kubernetes";
    name = "service-account-key.pem";
    user = "kubernetes";
    group = "kubernetes";
    permissions = "0400";

    uploadAt = "pre-activation";
  };
}

