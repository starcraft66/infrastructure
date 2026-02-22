{ lib, deployment, ... }:

let
  # Set this to true on the first deploy to install vault TLS certificates
  # This is disabled otherwise because it requires a lot of yubikey-confirming
  # due to the sops operations
  deploy-keys = false;
  patroniSecretsFile = toString ../../../secrets/patroni-235.yaml;
  pocketIdSecretsFile = toString ../../../secrets/pocket-id-235.yaml;
in
lib.mkIf deploy-keys {

  # Patroni secrets
  deployment.keys."patroni-replication-password" = {
    keyCommand = [
      "sops"
      "-d"
      "--extract"
      "[\"replication_password\"]"
      patroniSecretsFile
    ];
    destDir = "/var/lib/secrets/patroni";
    name = "replication-password";
    user = "patroni";
    group = "patroni";
    permissions = "0400";
    uploadAt = "pre-activation";
  };
  deployment.keys."patroni-superuser-password" = {
    keyCommand = [
      "sops"
      "-d"
      "--extract"
      "[\"superuser_password\"]"
      patroniSecretsFile
    ];
    destDir = "/var/lib/secrets/patroni";
    name = "superuser-password";
    user = "patroni";
    group = "patroni";
    permissions = "0400";
    uploadAt = "pre-activation";
  };
  deployment.keys."patroni-rewind-password" = {
    keyCommand = [
      "sops"
      "-d"
      "--extract"
      "[\"rewind_password\"]"
      patroniSecretsFile
    ];
    destDir = "/var/lib/secrets/patroni";
    name = "rewind-password";
    user = "patroni";
    group = "patroni";
    permissions = "0400";
    uploadAt = "pre-activation";
  };

  # Pocket ID secrets
  deployment.keys."pocket-id-environment" = {
    keyCommand = [
      "sops"
      "-d"
      "--extract"
      "[\"environment\"]"
      pocketIdSecretsFile
    ];
    destDir = "/var/lib/secrets/pocket-id";
    name = "environment";
    user = "pocket-id";
    group = "pocket-id";
    permissions = "0400";
    uploadAt = "pre-activation";
  };

  deployment.keys."vault-ca.pem" = {
    keyCommand = [
      "sops"
      "-d"
      "--extract"
      "[\"ca\"][\"cert\"]"
      (toString ../../../vault/pki/235/vault-mtls.yaml)
    ];

    destDir = "/etc/ssl/certs";
    name = "vault-ca.pem";
    user = "root";
    group = "root";
    permissions = "0644";

    uploadAt = "pre-activation";
  };
  deployment.keys."vault-cert.pem" = {
    keyCommand = [
      "sops"
      "-d"
      "--extract"
      "[\"vault\"][\"cert\"]"
      (toString ../../../vault/pki/235/vault-mtls.yaml)
    ];

    destDir = "/var/lib/vault";
    name = "vault-cert.pem";
    user = "vault";
    group = "vault";
    permissions = "0400";

    uploadAt = "pre-activation";
  };
  deployment.keys."vault-key.pem" = {
    keyCommand = [
      "sops"
      "-d"
      "--extract"
      "[\"vault\"][\"key\"]"
      (toString ../../../vault/pki/235/vault-mtls.yaml)
    ];

    destDir = "/var/lib/vault";
    name = "vault-key.pem";
    user = "vault";
    group = "vault";
    permissions = "0400";

    uploadAt = "pre-activation";
  };
  deployment.keys."service-account.pem" = {
    keyCommand = [
      "sops"
      "-d"
      "--extract"
      "[\"serviceaccount\"][\"pubkey\"]"
      (toString ../../../vault/pki/235/serviceaccount.yaml)
    ];

    destDir = "/var/lib/secrets/kubernetes";
    name = "service-account.pem";
    user = "kubernetes";
    group = "kubernetes";
    permissions = "0400";

    uploadAt = "pre-activation";
  };
  deployment.keys."service-account-key.pem" = {
    keyCommand = [
      "sops"
      "-d"
      "--extract"
      "[\"serviceaccount\"][\"privkey\"]"
      (toString ../../../vault/pki/235/serviceaccount.yaml)
    ];

    destDir = "/var/lib/secrets/kubernetes";
    name = "service-account-key.pem";
    user = "kubernetes";
    group = "kubernetes";
    permissions = "0400";

    uploadAt = "pre-activation";
  };
  deployment.keys."cloudflare-api-token" = {
    keyCommand = [
      "sops"
      "-d"
      "--extract"
      "[\"cloudflare\"][\"token\"]"
      (toString ../../../vault/pki/cloudflare.yaml)
    ];

    destDir = "/var/lib/secrets/acme";
    name = "cloudflare-api-token";
    user = "acme";
    group = "acme";
    permissions = "0400";

    uploadAt = "pre-activation";
  };
}
