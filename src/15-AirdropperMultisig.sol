// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ECDSA} from "../lib/openzeppelin/utils/cryptography/ECDSA.sol";

contract Vault {
    mapping(address user => uint256 amount) public balances;
    mapping(bytes32 hash => bool claimed) public claimedHash;
    address public signer;

    constructor(address _signer) {
        signer = _signer;
    }

    receive() external payable {}

    function claim(address user, uint256 amount, uint96 expiration, bytes memory signature)
        external
    {
        bytes32 hash = keccak256(abi.encodePacked(user, amount, expiration));
        require(block.timestamp <= expiration, "Expired claim");

        ECDSA.recover(hash, signature);

        require(claimedHash[hash] == false, "Already claimed");
        claimedHash[hash] = true;

        balances[user] += amount;
    }

    function withdraw(address user, uint256 amount) external {
        balances[user] -= amount;
        (bool ok,) = user.call{value: amount}("");
        require(ok, "Withdraw Failed");
    }
}
