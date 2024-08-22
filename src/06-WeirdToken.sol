// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IERC20} from "../lib/openzeppelin/token/ERC20/IERC20.sol";

contract Vault {
    mapping(address user => mapping(address token => uint256 amount)) public balances;

    function deposit(address token, uint256 amount) public {
        balances[msg.sender][token] += amount;
        IERC20(token).transferFrom(msg.sender, address(this), amount);
    }

    function withdraw(address token) external {
        uint256 amount = balances[msg.sender][token];
        balances[msg.sender][token] = 0;
        IERC20(token).transfer(msg.sender, amount);
    }
}
























// safeTransfer
// approve vs forceApprove vs safeApprove
// https://github.com/d-xo/weird-erc20
