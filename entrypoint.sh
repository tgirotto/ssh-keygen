#!/bin/sh
set -e

# Parse JSON input from stdin
INPUT=$(cat)

# Extract parameters using jq (we'll install it)
KEY_TYPE=$(echo "$INPUT" | jq -r '.[0].t // "rsa"')
KEY_BITS=$(echo "$INPUT" | jq -r '.[0].b // 2048')
KEY_COMMENT=$(echo "$INPUT" | jq -r '.[0].C // "generated@starthub"')
RAW_OUTPUT=$(echo "$INPUT" | jq -r '.[0].raw // false')

# Set default key type if not specified
if [ "$KEY_TYPE" = "null" ]; then
    KEY_TYPE="rsa"
fi

# Set default key bits if not specified
if [ "$KEY_BITS" = "null" ]; then
    KEY_BITS="2048"
fi

# Set default comment if not specified
if [ "$KEY_COMMENT" = "null" ]; then
    KEY_COMMENT="generated@starthub"
fi

# Create temporary directory for keys
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

# Generate SSH key pair based on type (suppress output)
if [ "$KEY_TYPE" = "ed25519" ]; then
    ssh-keygen -t ed25519 -C "$KEY_COMMENT" -f id_key -N "" >/dev/null 2>&1
elif [ "$KEY_TYPE" = "rsa" ]; then
    ssh-keygen -t rsa -b "$KEY_BITS" -C "$KEY_COMMENT" -f id_key -N "" >/dev/null 2>&1
else
    echo "{\"error\": \"Unsupported key type: $KEY_TYPE. Supported types: rsa, ed25519\"}" >&2
    exit 1
fi

# Read the generated keys
PRIVATE_KEY=$(cat id_key)
PUBLIC_KEY=$(cat id_key.pub)

# Output format based on raw flag
# if [ "$RAW_OUTPUT" = "true" ]; then
#     # Output raw keys (for direct use)
#     echo "PRIVATE_KEY:"
#     echo "$PRIVATE_KEY"
#     echo "PUBLIC_KEY:"
#     echo "$PUBLIC_KEY"
# else
    # Output as JSON array [private_key, public_key] with proper escaping

# fi

echo "[$(echo "$PRIVATE_KEY" | jq -R -s .), $(echo "$PUBLIC_KEY" | jq -R -s .)]"
# Cleanup
rm -rf "$TEMP_DIR"
