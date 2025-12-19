#!/bin/bash

# Load environment variables
set -a && source .env && set +a

# Deploy and verify contract
forge script script/DeployAndConfigureScore.sol:DeployAndConfigureScore \
  --rpc-url "$SONEIUM_RPC_URL" \
  --private-key "$MAINNET_PRIVATE_KEY" \
  --broadcast \
  --verify \
  --verifier blockscout \
  --verifier-url "https://soneium.blockscout.com/api" \
  -vvvv
