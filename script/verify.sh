
forge verify-contract \
  --chain-id 1868 \
  --compiler-version 0.8.17 \
  --num-of-optimizations 1000000 \
  --watch \
  --force \
  --skip-is-verified-check \
  --verifier blockscout \
  --verifier-url "https://soneium.blockscout.com/api" \
  0x1e807efc2416c6cd63cb3b01dc91232d6f02d50a \
  src/AiboNFT.sol:AiboNFT

# dumps whole input.json
  forge verify-contract \
  --chain-id 1868 \
  --compiler-version 0.8.17 \
  --num-of-optimizations 1000000 \
  --watch \
  --force \
  --skip-is-verified-check \
  --verifier blockscout \
  --verifier-url "https://soneium.blockscout.com/api" \
  --show-standard-json-input \
  --via-ir \
  0x1e807efc2416c6cd63cb3b01dc91232d6f02d50a \
  src/AiboNFT.sol:AiboNFT
