// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;

import "forge-std/Test.sol";
import "../src/baddieGame.sol";
import "../src/baddieNFT.sol";
import "../src/baddieToken.sol";

contract CounterTest is Test {
    BaddieGame public baddieGame;
    BaddieNFT public baddieNFT;
    BaddieToken public baddieToken;

    function setUp() public {
        baddieNFT = new BaddieNFT("BaddieNFT1", "BT1");
        baddieToken = new BaddieToken();
        baddieGame = new BaddieGame(address(baddieToken), address(baddieNFT));
        baddieGame.setPasscode(1, "celo");
        baddieToken.setMinter(address(baddieGame));
        baddieNFT.setMinter(address(baddieGame));
        baddieNFT.setBaseURI(
            "ipfs://QmSpabrmYzEnVYMdbj3o7TELgSKRBj3cePcLdQMLHN2sUK"
        );
    }

    function testlevel1() public {
        address player1 = makeAddr("player1");
        vm.startPrank(player1);
        baddieGame.getlevel1Tokens(8, "celo");
        baddieNFT.tokenURI(1);
        baddieToken.balanceOf(player1);
        vm.stopPrank();
    }
}
// 0x1efe491571bd423a448165c99131ddb0e8471e61 = erc20 token
// 0xfD3F70e69c5E4B0Da0347f7Dc8d21AbD82E162fD = nft
// 0xE7bAf7af54A5487C7C170b0a823d3436cd1df521 = baddieGame
