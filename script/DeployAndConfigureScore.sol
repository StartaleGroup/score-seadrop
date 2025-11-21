// SPDX-License-Identifier: MIT

// forge script script/DeployAndConfigureScore.s.sol --rpc-url $SEP_RPC --broadcast -vvvv --private-key $GACHA --etherscan-api-key $ETHERSCAN_API_KEY --verify --retries 10
// forge script script/DeployAndConfigureScore.s.sol --profile score.sepolia --broadcast -vvvv --verify --retries 10

pragma solidity 0.8.17;

import "forge-std/Script.sol";

import { ScoreSeason3 } from "../src/ScoreSeason3.sol";

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
        "ipfs://bafkreihciakmb6iwazbrvpo3x7xiel2jyajyxusuydtd7swfvs6ojlutjq"; // Score3 metadata pointing to image
    string contractURI =
        "ipfs://bafkreidzlpzq3dxz525l3ietxd5rux6wfwkggyztmoty34q4caqidyvxxe"; // Score3 contract info

    // Drop config
    uint16 feeBps = 0;
    uint80 mintPrice = 0 ether;
    uint16 maxTotalMintableByWallet = 1;
    uint48 startTime = 1763967600; // Monday, November 24, 2025 7:00:00 AM UTC
    uint48 endTime = 1765177200; // Monday, December 8, 2025 7:00:00 AM UTC
    // uint48 endTimeStage3 = 1766386800; // Monday, December 22, 2025 7:00:00 AM UTC


    function run() external {
        vm.startBroadcast();

        console.log("Start time: %s", startTime);
        console.log("End time: %s", endTime);
        address[] memory allowedSeadrop = new address[](1);
        allowedSeadrop[0] = seadrop;

        ScoreSeason3 token = new ScoreSeason3();

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
