#!/usr/bin/env bash

set -euo pipefail

# Define the sops-encrypted file path
sops_file="vault-mtls.yaml"

# Check if CA certificate and key exist in sops file
if sops -d --extract '["ca"]["cert"]' "$sops_file" 2>/dev/null && \
   sops -d --extract '["ca"]["key"]' "$sops_file" 2>/dev/null; then
    echo "CA certificate and key retrieved from sops file"
else
  # Generate a new certificate authority with cfssl
  new_ca_output=$(cfssl gencert -initca ca-csr.json)
  new_ca=$(echo "$new_ca_output" | jq -r .)
  # Store CA certificate and key in sops file
  echo '{"ca": "dummy"}' > "$sops_file"
  sops --encrypt --in-place --input-type json --output-type yaml "$sops_file"
  sops --set "[\"ca\"] $new_ca" "$sops_file"
  echo "New CA certificate and key generated and stored in sops"
fi

# Retrieve the certificate authority files from sops
ca_crt=$(sops -d --extract "[\"ca\"][\"cert\"]" "$sops_file")
ca_key=$(sops -d --extract "[\"ca\"][\"key\"]" "$sops_file")

# Perform operations using the certificate authority files
new_certificate_output=$(cfssl gencert -ca=<(echo "$ca_crt") -ca-key=<(echo "$ca_key") -config ca-config.json -profile peer vault-csr.json)
new_certificate=$(echo "$new_certificate_output" | jq -r .)
sops --set "[\"vault\"] $new_certificate" "$sops_file"

echo "Operations completed successfully."