#!/bin/bash

# Load environment variables
source .env

# Deploy and verify contract
forge script script/DeployAndConfigureAibo.sol:DeployAndConfigureAibo \
  --rpc-url "$SEPOLIA_RPC_URL" \
  --private-key "$TESTNET_PRIVATE_KEY" \
  --broadcast \
  --verify \
  --verifier blockscout \
  --verifier-url "https://eth-sepolia.blockscout.com/api" \
  -vvvv