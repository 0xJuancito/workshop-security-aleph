// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC20} from "../lib/solmate/ERC20.sol";
import {SafeTransferLib} from "../lib/solmate/SafeTransferLib.sol";

contract Vault {
    using SafeTransferLib for ERC20;

    mapping(address user => mapping(address token => uint256 amount)) public balances;

    function deposit(address token, uint256 amount) public {
        balances[msg.sender][token] += amount;
        ERC20(token).safeTransferFrom(msg.sender, address(this), amount);
    }

    function withdraw(address token) external {
        uint256 amount = balances[msg.sender][token];
        balances[msg.sender][token] = 0;
        ERC20(token).safeTransfer(msg.sender, amount);
    }
}
