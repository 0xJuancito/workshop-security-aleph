// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {MerkleProof} from "../lib/openzeppelin/utils/cryptography/MerkleProof.sol";

contract Vault {
    mapping(address user => uint256 amount) public balances;
    mapping(bytes32 leaf => bool claimed) public claimedLeaf;
    address public owner;
    bytes32 root;

    constructor() {
        owner = msg.sender;
    }

    receive() external payable {}

    function setMerkleRoot(bytes32 _root) external {
        require(msg.sender == owner, "Not owner");
        root = _root;
    }

    function claim(address[] memory users, uint256[] memory amounts, uint96 expiration, bytes32[] memory proof)
        external
    {
        bytes32 leaf = keccak256(abi.encodePacked(users, amounts, expiration));
        require(block.timestamp <= expiration, "Expired claim");

        require(MerkleProof.verify(proof, root, leaf), "Proof not valid");

        require(claimedLeaf[leaf] == false, "Already claimed");
        claimedLeaf[leaf] = true;

        for (uint256 i = 0; i < users.length; i++) {
            address user = users[i];
            uint256 amount = amounts[i];

            balances[user] += amount;
        }
    }

    function withdraw(address user, uint256 amount) external {
        balances[user] -= amount;
        (bool ok,) = user.call{value: amount}("");
        require(ok, "Withdraw Failed");
    }
}
