// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

struct Deposit {
    address user;
    uint256 amount;
}

contract Vault {
    address public owner;
    Deposit[] public deposits;

    constructor() {
        owner = msg.sender;
    }

    function deposit() external payable {
        Deposit memory newDeposit = Deposit({user: msg.sender, amount: msg.value});
        deposits.push(newDeposit);
    }

    function distribute() external {
        require(msg.sender == owner);

        for (uint256 i = 0; i < deposits.length; i++) {
            uint256 amount = deposits[i].amount;
            address to = deposits[i].user;

            (bool ok,) = to.call{value: amount}("");
            require(ok, "Distribute Failed");
        }

        delete deposits;
    }
}
