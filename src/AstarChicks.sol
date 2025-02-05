// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {
    ERC721SeaDropSoulbound
} from "./extensions/ERC721SeaDropSoulbound.sol";

contract AstarChicks is ERC721SeaDropSoulbound {
    string public constant uri = "";
    constructor(
        string memory name,
        string memory symbol,
        address[] memory allowedSeaDrop
    ) ERC721SeaDropSoulbound(name, symbol, allowedSeaDrop) {}

    function tokenURI(
        uint256 tokenId
    ) public view virtual override returns (string memory) {
        if (!_exists(tokenId)) revert URIQueryForNonexistentToken();

        string memory baseURI = _baseURI();

        // Exit early if the baseURI is empty.
        if (bytes(baseURI).length == 0) {
            return "";
        }

        // Check if the last character in baseURI is a slash.
        if (bytes(baseURI)[bytes(baseURI).length - 1] != bytes("/")[0]) {
            return baseURI;
        }

        return string(abi.encodePacked(baseURI, _toString(tokenId)));
    }
}
