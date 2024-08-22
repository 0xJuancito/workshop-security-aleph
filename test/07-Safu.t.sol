// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Vault} from "../src/07-Safu.sol";
import {ERC20} from "../lib/openzeppelin/token/ERC20/ERC20.sol";

contract SafuTest is Test {
    address user;
    Vault public vault;

    function setUp() public {
        vault = new Vault();

        user = makeAddr("USER");
    }

    function test_Safu() public {
        address attacker = makeAddr("ATTACKER");

        vm.startPrank(attacker);

        // START OF SOLUTION
        // (You can create any additional contract if needed)

        

        // END OF SOLUTION

        vm.stopPrank();

        vm.startPrank(user);
        ERC20 token = new ERC20("", "");
        deal(address(token), user, 100);
        token.approve(address(vault), 100);
        vault.deposit(address(token), 100);
        vm.stopPrank();

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
