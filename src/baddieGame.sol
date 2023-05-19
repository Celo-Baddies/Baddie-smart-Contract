// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

////////////////////////////////////////////////////////
/////////////////                 //////////////////////
////////////////   BADDIEGAME     //////////////////////
////////////////                  //////////////////////
////////////////////////////////////////////////////////

import {Ownable} from "@openzeppelin/access/Ownable.sol";
import {IBaddieToken} from "./IBaddieToken.sol";
import {IBaddieNFT} from "./IBaddieToken.sol";

contract BaddieGame is Ownable {
    //// STATE VARIABLES /////
    // baddie erc2o token
    address immutable BaddieToken;
    // game level to the address of the NFT certificate
    mapping(uint => address) BaddieNFT;
    // game level to the passcode
    mapping(uint => bytes32) levelPasscode;
    // game level to the passcode
    mapping(address => mapping(uint => bool)) levelpassed;
    /// multiplier for game point
    uint constant MULTIPLIER = 10 * 1e18;

    //// CUSTOM ERRORS  /////
    error addressZero();
    /// EVENTS ////////
    event levelCompleted(
        address indexed champ,
        uint indexed _points,
        uint level
    );
    event setLevel(address indexed nft, uint indexed level, bool status);

    constructor(address _baddieToken, address _baddieNFT) {
        if ((_baddieNFT == address(0)) || (_baddieToken == address(0)))
            revert addressZero();
        BaddieToken = _baddieToken;
        BaddieNFT[1] = _baddieNFT;
    }

    /// @notice claim tokens and nft for level 1
    /// @dev mint erc20 and nft for players
    /// @param point The Accumulated score gotten from playing level 1
    /// @param _passcode The random string set as passcode to avoid abitrary minting by random users.

    function getlevel1Tokens(uint point, string memory _passcode) external {
        bytes32 passcode_ = levelPasscode[1];
        require(keccak256(abi.encode(_passcode)) == passcode_, "wrong code");
        require(point >= 8, "you need 8 point to get this token");
        require(!levelpassed[msg.sender][1], "level completed, try level 2");
        levelpassed[msg.sender][1] = true;
        uint amountToMint = point * MULTIPLIER;
        IBaddieToken(BaddieToken).mintToken(msg.sender, amountToMint);
        address _baddieNFT = BaddieNFT[1];
        IBaddieNFT(_baddieNFT).MintlevelNFT(msg.sender);

        emit levelCompleted(msg.sender, amountToMint, 1);
    }

    /// @notice claim tokens and nft for level 2
    /// @dev mint erc20 and nft for players
    /// @param point The Accumulated score gotten from playing level 2
    /// @param _passcode2 The random string set as passcode to avoid abitrary minting by random users.

    function getlevel2Tokens(uint point, uint _passcode2) external {
        bytes32 passcode_ = levelPasscode[1];
        require(keccak256(abi.encode(_passcode2)) == passcode_, "wrong code");
        require(
            (levelpassed[msg.sender][1]) && (!levelpassed[msg.sender][2]),
            "this is level2, you can try level 3 if you have passes level 2"
        );
        levelpassed[msg.sender][2] = true;
        uint amountToMint = point * MULTIPLIER;
        IBaddieToken(BaddieToken).mintToken(msg.sender, amountToMint);
        address _baddieNFT = BaddieNFT[2];
        IBaddieNFT(_baddieNFT).MintlevelNFT(msg.sender);
        emit levelCompleted(msg.sender, amountToMint, 2);
    }

    /// @notice claim tokens and nft for level 3
    /// @dev mint erc20 and nft for players
    /// @param point The Accumulated score gotten from playing level 3
    /// @param _passcode3 The random string set as passcode to avoid abitrary minting by random users.

    function getlevel3Tokens(uint point, uint _passcode3) external {
        bytes32 passcode_ = levelPasscode[3];
        require(keccak256(abi.encode(_passcode3)) == passcode_, "wrong code");
        require(
            levelpassed[msg.sender][2],
            "go back and complete the previous levels"
        );
        levelpassed[msg.sender][3] = true;
        uint amountToMint = point * MULTIPLIER;
        IBaddieToken(BaddieToken).mintToken(msg.sender, amountToMint);
        address _baddieNFT = BaddieNFT[3];
        IBaddieNFT(_baddieNFT).MintlevelNFT(msg.sender);
    }

    /// @notice allow onlyOwner set the nft certificate for each levels
    /// @dev Owner set the nft address for each levels
    /// @param level The game level to for which certificate has not been set
    /// @param NFT the contract address of the NFT certificate.

    function setlevelNft(uint level, address NFT) external onlyOwner {
        require(BaddieNFT[level] == address(0), "this level has been set");
        BaddieNFT[level] = NFT;
        emit setLevel(NFT, level, true);
    }

    /// @notice allow onlyOwner set the passcode to use for each levels
    /// @dev Owner set the passcode for each levels
    /// @param level The game level to for which which passcode is to be set
    /// @param _passcode trandom string to be set as passcode.

    function setPasscode(uint level, string memory _passcode) external {
        bytes32 code = keccak256(abi.encode(_passcode));
        levelPasscode[level] = code;
    }
}
