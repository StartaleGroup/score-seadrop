#!/bin/bash

# Load environment variables
source .env

# Deploy and verify contract
forge script script/DeployAndConfigureAibo.sol:DeployAndConfigureAibo \
  --rpc-url "$SONEIUM_RPC_URL" \
  --private-key "$MAINNET_PRIVATE_KEY" \
  --broadcast \
  --verify \
  --verifier blockscout \
  --verifier-url "https://soneium.blockscout.com/api" \
  -vvvv