#!/bin/bash

# Load environment variables
set -a && source .env && set +a

# Deploy and verify contract
forge script script/DeployAndConfigureScore.sol:DeployAndConfigureScore \
  --rpc-url "$SEPOLIA_RPC_URL" \
  --private-key "$TESTNET_PRIVATE_KEY" \
  --broadcast \
  --verify \
  --verifier blockscout \
  --verifier-url "https://eth-sepolia.blockscout.com/api" \
  -vvvv