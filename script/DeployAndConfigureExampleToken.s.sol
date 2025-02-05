// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "forge-std/Script.sol";

import { AstarChicks } from "../src/AstarChicks.sol";

import { ERC721SeaDrop } from "../src/ERC721SeaDrop.sol";

import { ISeaDrop } from "../src/interfaces/ISeaDrop.sol";

import { PublicDrop } from "../src/lib/SeaDropStructs.sol";

contract DeployAndConfigureExampleToken is Script {
    // Addresses
    address seadrop = 0x00005EA00Ac477B1030CE78506496e8C2dE24bf5;
    address creator = 0x911d82b108804A18022d0A2621B2Fc608DEF6FCA;
    address feeRecipient = 0x911d82b108804A18022d0A2621B2Fc608DEF6FCA;

    // Token config
    uint256 maxSupply = 1000;

    // Drop config
    uint16 feeBps = 0; // 5%
    uint80 mintPrice = 0 ether;
    uint16 maxTotalMintableByWallet = 10;

    function run() external {
        vm.startBroadcast();

        address[] memory allowedSeadrop = new address[](1);
        allowedSeadrop[0] = seadrop;

        AstarChicks token = new AstarChicks(
            "AstarChicks",
            "ACHICK",
            allowedSeadrop
        );

        // Configure the token.
        token.setMaxSupply(maxSupply);

        // Configure the drop parameters.
        token.updateCreatorPayoutAddress(seadrop, creator);
        token.updateAllowedFeeRecipient(seadrop, feeRecipient, true);
        token.updatePublicDrop(
            seadrop,
            PublicDrop(
                mintPrice,
                uint48(block.timestamp), // start time
                uint48(block.timestamp) + 10000, // end time
                maxTotalMintableByWallet,
                feeBps,
                true
            )
        );

        // We are ready, let's mint the first 3 tokens!
        ISeaDrop(seadrop).mintPublic{ value: mintPrice * 3 }(
            address(token),
            feeRecipient,
            address(0),
            3 // quantity
        );
    }
}
