// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Vault {
    mapping(address user => uint256 amount) public balances;

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() external {
        uint256 amount = balances[msg.sender];

        (bool ok,) = msg.sender.call{value: amount}("");
        require(ok, "Withdraw Failed");

        balances[msg.sender] = 0;
    }
}
