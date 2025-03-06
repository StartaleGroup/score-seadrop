// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {
    ERC721SeaDropSoulbound
} from "./extensions/ERC721SeaDropSoulbound.sol";

string constant NAME = "Entertainment Robot aibo by Sony";
string constant SYMBOL = "AIBO";

contract AiboNFT is ERC721SeaDropSoulbound {
    address[] seadrop = [0x00005EA00Ac477B1030CE78506496e8C2dE24bf5];

    constructor() ERC721SeaDropSoulbound(NAME, SYMBOL, seadrop) {}
}
