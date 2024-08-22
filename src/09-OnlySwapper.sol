// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IERC20} from "../lib/openzeppelin/token/ERC20/IERC20.sol";
import {SafeERC20} from "../lib/openzeppelin/token/ERC20/utils/SafeERC20.sol";
import {ReentrancyGuard} from "../lib/openzeppelin/security/ReentrancyGuard.sol";

contract Vault is ReentrancyGuard {
    using SafeERC20 for IERC20;

    function swap(
        address _tokenIn,
        uint256 amountIn,
        address _tokenOut,
        uint256 minAmountOut,
        address swapper,
        bytes calldata data
    ) external nonReentrant {
        IERC20 tokenIn = IERC20(_tokenIn);
        IERC20 tokenOut = IERC20(_tokenOut);

        tokenIn.safeTransferFrom(msg.sender, address(this), amountIn);
        tokenIn.approve(swapper, amountIn);

        (bool ok,) = swapper.call(data);
        require(ok, "Swap Failed");

        tokenIn.approve(swapper, 0);

        uint256 amountOut = tokenOut.balanceOf(address(this));
        require(amountOut >= minAmountOut, "Slippage");
        tokenOut.transfer(msg.sender, amountOut);
    }
}
