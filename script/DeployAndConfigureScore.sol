// SPDX-License-Identifier: MIT

// forge script script/DeployAndConfigureScore.s.sol --rpc-url $SEP_RPC --broadcast -vvvv --private-key $GACHA --etherscan-api-key $ETHERSCAN_API_KEY --verify --retries 10
// forge script script/DeployAndConfigureScore.s.sol --profile score.sepolia --broadcast -vvvv --verify --retries 10

pragma solidity 0.8.17;

import "forge-std/Script.sol";

import { ScoreSeason6 } from "../src/ScoreSeason6.sol";

import { ERC721SeaDrop } from "../src/ERC721SeaDrop.sol";

import { ISeaDrop } from "../src/interfaces/ISeaDrop.sol";

import { PublicDrop } from "../src/lib/SeaDropStructs.sol";

contract DeployAndConfigureScore is Script {
    // Addresses
    address seadrop = 0x00005EA00Ac477B1030CE78506496e8C2dE24bf5;
    address creator = 0xEE70e6d461F0888Fd9DB60cb5B2e933adF5f4c7C;
    address feeRecipient = 0xEE70e6d461F0888Fd9DB60cb5B2e933adF5f4c7C;

    // Token config
    uint256 maxSupply = 40000;
    string baseURI =
        "ipfs://bafkreierguuzqnvybodqnyt2lcwgjv5fyskzgkqoylucm2kl7oeyrdd75q"; // Score6 metadata pointing to image
    string contractURI =
        "ipfs://bafkreigmcur4mf6eukepwmjjgx3psms6nk5mi6i7t3srnumftrtx4qhdvy"; // Score6 contract info

    // Drop config
    uint16 feeBps = 0;
    uint80 mintPrice = 1000 ether;
    uint16 maxTotalMintableByWallet = 1;
    uint48 startTime = 1771225200; // (GMT): Monday, February 16, 2026 7:00:00 AM
    uint48 endTime = 1773644400; // (GMT): Monday, March 16, 2026 7:00:00 AM


    function run() external {
        vm.startBroadcast();

        console.log("Start time: %s", startTime);
        console.log("End time: %s", endTime);
        address[] memory allowedSeadrop = new address[](1);
        allowedSeadrop[0] = seadrop;

        ScoreSeason6 token = new ScoreSeason6();

        // Configure the token.
        token.setMaxSupply(maxSupply);
        console.log("Token max supply set to: %s", maxSupply);
        token.setBaseURI(baseURI);
        console.log("Token base URI set to: %s", baseURI);
        token.setContractURI(contractURI);
        console.log("Token contract URI set to: %s", contractURI);

        // Configure the drop parameters.
        token.updateCreatorPayoutAddress(seadrop, creator);
        console.log("Creator payout address set to: %s", creator);

        token.updateAllowedFeeRecipient(seadrop, feeRecipient, true);
        console.log("Allowed fee recipient set to: %s", feeRecipient);

        token.updatePublicDrop(
            seadrop,
            PublicDrop(
                mintPrice,
                startTime,
                endTime,
                maxTotalMintableByWallet,
                feeBps,
                false
            )
        );

        // We are ready, let's mint the first 1 token!
        // ISeaDrop(seadrop).mintPublic{ value: mintPrice * 1 }(
        //     address(token),
        //     feeRecipient,
        //     address(0),
        //     1 // quantity
        // );
    }
}
