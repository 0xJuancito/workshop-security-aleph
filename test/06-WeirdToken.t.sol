// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Vault} from "../src/06-WeirdToken.sol";
import {USDT} from "../lib/tokens/USDT.sol";
import {IERC20} from "../lib/openzeppelin/token/ERC20/IERC20.sol";

contract WeirdTokenTest is Test {
    address user;
    address token;
    Vault public vault;

    function setUp() public {
        vault = new Vault();
        token = address(new USDT(1_000_000e6));

        user = makeAddr("USER");
        deal(token, user, 100);
    }

    function test_WeirdToken() public {
        // START OF SOLUTION

        // Modify `WeirdToken.sol` to make the tests pass

        // END OF SOLUTION

        vm.startPrank(user);

        USDT(token).approve(address(vault), 100);

        vault.deposit(token, 100);
        assertEq(IERC20(token).balanceOf(user), 0);
        assertEq(IERC20(token).balanceOf(address(vault)), 100);

        vault.withdraw(token);
        assertEq(IERC20(token).balanceOf(user), 100);
        assertEq(IERC20(token).balanceOf(address(vault)), 0);
    }
}
