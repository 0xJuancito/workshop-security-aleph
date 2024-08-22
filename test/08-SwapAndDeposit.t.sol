// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Vault} from "../src/08-SwapAndDeposit.sol";
import {ERC20} from "../lib/openzeppelin/token/ERC20/ERC20.sol";

contract SwapAndDepositTest is Test {
    ERC20 token;
    Vault public vault;

    function setUp() public {
        token = new ERC20("", "");
        vault = new Vault(address(token));

        address user = makeAddr("USER");
        deal(address(token), user, 100);

        vm.startPrank(user);
        token.approve(address(vault), type(uint256).max);
        vault.deposit(100);
        vm.stopPrank();
    }

    function test_SwapAndDeposit() public {
        address attacker = makeAddr("ATTACKER");

        vm.startPrank(attacker);

        // START OF SOLUTION
        // (You can create any additional contract if needed)

        

        // END OF SOLUTION

        uint256 vaultBalance = token.balanceOf(address(vault));
        assertEq(vaultBalance, 0, "Vault still has balance");

        uint256 attackerBalance = token.balanceOf(attacker);
        assertEq(attackerBalance, 100, "Attacker didn't steal the assets");
    }
}