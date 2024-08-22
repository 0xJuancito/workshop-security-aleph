// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Pausable} from "../lib/openzeppelin/security/Pausable.sol";

contract Vault is Pausable {
    address owner;
    mapping(address user => uint256 amount) public balances;

    constructor() {
        owner = msg.sender;
    }

    function deposit() external payable whenNotPaused {
        balances[msg.sender] += msg.value;
    }

    function withdraw() external whenNotPaused {
        uint256 amount = balances[msg.sender];
        balances[msg.sender] = 0;

        (bool ok,) = msg.sender.call{value: amount}("");
        require(ok, "Withdraw Failed");
    }
}


























// pause/unpause functions
// liquidations
// upgradeables
// timelocks
// speed bump