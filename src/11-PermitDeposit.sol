// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IERC20} from "../lib/openzeppelin/token/ERC20/IERC20.sol";
import {SafeERC20} from "../lib/openzeppelin/token/ERC20/utils/SafeERC20.sol";
import {IERC20Permit} from "../lib/openzeppelin/token/ERC20/extensions/IERC20Permit.sol";
import {ReentrancyGuard} from "../lib/openzeppelin/security/ReentrancyGuard.sol";

struct Permit {
    address token;
    address from;
    uint256 amount;
    uint256 deadline;
    uint8 v;
    bytes32 r;
    bytes32 s;
}

contract Vault is ReentrancyGuard {
    using SafeERC20 for IERC20;

    mapping(address user => mapping(address token => uint256 amount)) public balances;

    function deposit(address token, uint256 amount, address receiver) external nonReentrant {
        _deposit(token, amount, msg.sender, receiver);
    }

    function permitDeposit(Permit memory p, address receiver) external nonReentrant {
        IERC20Permit(p.token).permit(p.from, address(this), p.amount, p.deadline, p.v, p.r, p.s);
        return _deposit(p.token, p.amount, p.from, receiver);
    }

    function _deposit(address token, uint256 amount, address from, address receiver) internal {
        balances[receiver][token] += amount;
        IERC20(token).safeTransferFrom(from, address(this), amount);
    }

    function withdraw(address token) external nonReentrant {
        uint256 amount = balances[msg.sender][token];
        balances[msg.sender][token] = 0;
        IERC20(token).safeTransfer(msg.sender, amount);
    }
}
