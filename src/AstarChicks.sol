// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {
    ERC721SeaDropSoulbound
} from "./extensions/ERC721SeaDropSoulbound.sol";

contract AstarChicks is ERC721SeaDropSoulbound {
    constructor(
        string memory name,
        string memory symbol,
        address[] memory allowedSeaDrop
    ) ERC721SeaDropSoulbound(name, symbol, allowedSeaDrop) {}
}
