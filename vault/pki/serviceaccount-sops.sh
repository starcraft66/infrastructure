#!/usr/bin/env bash

set -euo pipefail

# Define the sops-encrypted file path
sops_file="serviceaccount.yaml"

IFS=

# Check if CA certificate and key exist in sops file
if sops -d --extract '["pubkey"]' "$sops_file" 2>/dev/null && \
   sops -d --extract '["privkey"]' "$sops_file" 2>/dev/null; then
    echo "Service account public and private key already exist in sops file"
else
  # Generate a new RSA keypair
  private_key=$(openssl genrsa 4096 2>/dev/null)
  public_key=$(openssl rsa -in <(echo "$private_key") -pubout 2>/dev/null)
  key_json_full=$(jq -n --arg privkey "$private_key" --arg pubkey "$public_key" '{"privkey": $privkey, "pubkey": $pubkey}')
  # Store keypair in sops file
  echo '{"serviceaccount": "dummy"}' > "$sops_file"
  sops --encrypt --in-place --input-type json --output-type yaml "$sops_file"
  sops --set "[\"serviceaccount\"] $key_json_full" "$sops_file"
  echo "New service account public and private key generated and stored in sops"
fi

echo "Operations completed successfully."