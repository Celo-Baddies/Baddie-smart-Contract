// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

interface IBaddieToken {
    function mintToken(address to, uint amount) external;

    function balanceOf(address account) external view returns (uint256);
}

interface IBaddieNFT {
    function MintlevelNFT(address to) external;
}
