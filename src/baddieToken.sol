// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;
import {ERC20} from "@openzeppelin/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/access/Ownable.sol";

contract BaddieToken is ERC20, Ownable {
    error Notallowed();
    address baddieGame;

    constructor() ERC20("baddieToken", "BDT") {}

    modifier onlyMinter() {
        require(msg.sender == baddieGame, "not a legal minter");
        _;
    }

    function mintToken(address to, uint amount) external onlyMinter {
        _mint(to, amount);
    }

    function setMinter(address _minter) external onlyOwner {
        require(_minter != address(0), "invalid address");
        baddieGame = _minter;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public override returns (bool) {
        revert Notallowed();
    }

    function transfer(
        address to,
        uint256 amount
    ) public override returns (bool) {
        revert Notallowed();
    }
}
