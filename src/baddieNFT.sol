// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

import {ERC721} from "@openzeppelin/token/ERC721/ERC721.sol";
import {Ownable} from "@openzeppelin/access/Ownable.sol";

contract BaddieNFT is ERC721, Ownable {
    string BaseURI;
    uint totalSupply;
    address baddieGame;

    constructor(
        string memory _name,
        string memory _symbol
    ) ERC721("_name", "_symbol") {}

    modifier onlyMinter() {
        require(msg.sender == baddieGame, "not a legal minter");
        _;
    }

    function setBaseURI(string memory baseURI_) external onlyOwner {
        BaseURI = baseURI_;
    }

    function setMinter(address _minter) external onlyOwner {
        require(_minter != address(0), "invalid address");
        baddieGame = _minter;
    }

    function _baseURI() internal view override returns (string memory) {
        return BaseURI;
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        _requireMinted(tokenId);

        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 ? baseURI : "";
    }

    function MintlevelNFT(address to) external onlyMinter {
        totalSupply++;
        _safeMint(to, totalSupply);
    }
}
