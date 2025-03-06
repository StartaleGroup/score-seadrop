#!/bin/bash

# Set compiler version and optimization
COMPILER_VERSION="0.8.17"
OPTIMIZER_RUNS="1000000"

# Build with specific settings and extract input
FOUNDRY_OPTIMIZER=true \
FOUNDRY_OPTIMIZER_RUNS=$OPTIMIZER_RUNS \
FOUNDRY_SOLC_VERSION=$COMPILER_VERSION \
forge build --json | jq '.input' > verification-input.json

echo "Verification input saved to verification-input.json"