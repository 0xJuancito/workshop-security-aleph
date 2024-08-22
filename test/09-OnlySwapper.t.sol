// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Vault} from "../src/09-OnlySwapper.sol";
import {ERC20} from "../lib/openzeppelin/token/ERC20/ERC20.sol";

contract OnlySwapperTest is Test {
    address user;
    ERC20 token;
    Vault public vault;

    function setUp() public {
        token = new ERC20("", "");
        vault = new Vault();

        user = makeAddr("USER");
        deal(address(token), user, 100);

        vm.startPrank(user);
        token.approve(address(vault), type(uint256).max);
        // will .swap() later
        vm.stopPrank();
    }

    function test_OnlySwapper() public {
        address attacker = makeAddr("ATTACKER");

        vm.startPrank(attacker);

        // START OF SOLUTION
        // (You can create any additional contract if needed)

        

        // END OF SOLUTION

        uint256 vaultBalance = token.balanceOf(address(user));
        assertEq(vaultBalance, 0, "User still has balance");

        uint256 attackerBalance = token.balanceOf(attacker);
        assertEq(attackerBalance, 100, "Attacker didn't steal all the assets");
    }
}
