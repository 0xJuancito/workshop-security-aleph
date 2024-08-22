// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Vault} from "../src/10-OptimisticSwapper.sol";
import {ERC20} from "../lib/openzeppelin/token/ERC20/ERC20.sol";

contract OptimisticSwapperTest is Test {
    ERC20 token;
    Vault public vault;

    function setUp() public {
        vm.createSelectFork("https://mainnet.optimism.io", 124342834);

        token = ERC20(0x7F5c764cBc14f9669B88837ca1490cCa17c31607); // Optimism USDC
        vault = new Vault(address(token));

        address user = makeAddr("USER");
        deal(address(token), user, 100);

        vm.startPrank(user);
        token.approve(address(vault), type(uint256).max);
        vault.deposit(100);
        vm.stopPrank();
    }

    function test_OptimisticSwapper() public {
        address attacker = makeAddr("ATTACKER");

        vm.startPrank(attacker);

        // START OF SOLUTION
        // (You can create any additional contract if needed)

        

        // END OF SOLUTION

        uint256 vaultBalance = token.balanceOf(address(vault));
        assertEq(vaultBalance, 0, "Vault still has balance");
    }
}