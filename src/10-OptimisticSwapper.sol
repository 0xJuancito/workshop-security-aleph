// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IERC20} from "../lib/openzeppelin/token/ERC20/IERC20.sol";
import {SafeERC20} from "../lib/openzeppelin/token/ERC20/utils/SafeERC20.sol";
import {ReentrancyGuard} from "../lib/openzeppelin/security/ReentrancyGuard.sol";

contract Vault is ReentrancyGuard {
    using SafeERC20 for IERC20;

    mapping(address user => uint256 amount) public balances;
    IERC20 public token;

    constructor(address _token) {
        token = IERC20(_token);
    }

    function deposit(uint256 amount) public nonReentrant {
        _deposit(amount);
    }

    function _deposit(uint256 amount) internal {
        balances[msg.sender] += amount;
        token.safeTransferFrom(msg.sender, address(this), amount);
    }

    function withdraw() external nonReentrant {
        uint256 amount = balances[msg.sender];
        balances[msg.sender] = 0;
        token.safeTransfer(msg.sender, amount);
    }

    function swapAndDeposit(address _tokenIn, uint256 amountIn, uint256 minAmountOut, address swapper, bytes calldata data)
        external
        nonReentrant
    {
        IERC20 tokenIn = IERC20(_tokenIn);

        bytes4 selector = bytes4(data[:4]);
        require(
            selector != IERC20.transfer.selector && selector != IERC20.transferFrom.selector
                && selector != IERC20.approve.selector
        );

        uint256 amountBefore = token.balanceOf(address(this));

        tokenIn.safeTransferFrom(msg.sender, address(this), amountIn);
        tokenIn.approve(swapper, amountIn);

        (bool ok,) = swapper.call(data);
        require(ok, "Swap Failed");

        tokenIn.approve(swapper, 0);

        uint256 amountAfter = token.balanceOf(address(this));
        if (amountAfter > minAmountOut && amountAfter > amountBefore) {
            uint256 amountOut = amountAfter - amountBefore;
            _deposit(amountOut);
        }
    }
}
