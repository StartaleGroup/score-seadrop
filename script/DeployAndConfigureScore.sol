// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

import "forge-std/Script.sol";

import { ScoreSeason12 } from "../src/ScoreSeason12.sol";

import { ERC721SeaDrop } from "../src/ERC721SeaDrop.sol";

import { ISeaDrop } from "../src/interfaces/ISeaDrop.sol";

import { PublicDrop } from "../src/lib/SeaDropStructs.sol";

contract DeployAndConfigureScore is Script {
    // Addresses
    address seadrop = 0x00005EA00Ac477B1030CE78506496e8C2dE24bf5;
    address creator = 0xCc6b7dAa102d15110015825e5DFe89C13c447A19;
    address feeRecipient = 0xCc6b7dAa102d15110015825e5DFe89C13c447A19;

    // Token config
    uint256 maxSupply = 40000;
    string baseURI =
        "ipfs://bafkreignuqz4uvjk7pbbrxetz4fkjbjywqrga4vcawny7yri6tuu3tutie"; // Score12 metadata pointing to image
    string contractURI =
        "ipfs://bafkreiffpkfozcq2dv7wsf4uccyzhlmxt4n644q3r54ohhvvrhfp6qgzke"; // Score12 contract info

    // Drop config
    uint16 feeBps = 0;
    uint80 mintPrice = 1000 ether;
    uint16 maxTotalMintableByWallet = 1;
    uint48 startTime = 1785913200; // (GMT): Wednesday, August 5, 2026 at 7:00:00 AM
    uint48 endTime = 1788315600; // (GMT): Wednesday, August 19, 2026 at 7:00:00 AM

    function run() external {
        vm.startBroadcast();

        console.log("Start time: %s", startTime);
        console.log("End time: %s", endTime);
        address[] memory allowedSeadrop = new address[](1);
        allowedSeadrop[0] = seadrop;

        ScoreSeason12 token = new ScoreSeason12();

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
