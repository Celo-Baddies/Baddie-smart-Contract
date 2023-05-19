// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;

import "forge-std/Script.sol";
import "../src/baddieGame.sol";
import "../src/baddieNFT.sol";
import "../src/baddieToken.sol";

contract BaddieScript is Script {
    BaddieGame public baddieGame;
    BaddieNFT public baddieNFT;
    BaddieToken public baddieToken;

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        baddieNFT = new BaddieNFT("BaddieNFT1", "BDT1");
        baddieToken = new BaddieToken();
        baddieGame = new BaddieGame(address(baddieToken), address(baddieNFT));
        baddieToken.setMinter(address(baddieGame));
        baddieNFT.setMinter(address(baddieGame));
        baddieNFT.setBaseURI(
            "ipfs://QmSpabrmYzEnVYMdbj3o7TELgSKRBj3cePcLdQMLHN2sUK"
        );

        vm.stopBroadcast();
    }
}
