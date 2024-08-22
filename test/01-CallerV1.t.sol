// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Vault, SmartWalletReceiver} from "../src/01-CallerV1.sol";

contract CallerV1Test is Test {
    address user;
    Vault public vault;

    function setUp() public {
        vault = new Vault();

        user = address(new SmartWalletReceiver());
        vm.deal(user, 10 ether);
        vm.prank(user);
        vault.deposit{value: 10 ether}();
    }

    function test_CallerV1() public {
        address attacker = makeAddr("ATTACKER");
        vm.deal(attacker, 1 ether);

        vm.startPrank(attacker);

        // START OF SOLUTION
        // (You can create any additional contract if needed)

        

        // END OF SOLUTION

        vm.stopPrank();
        vm.startPrank(user);
        vault.withdraw();

        uint256 userBalanceETH = address(user).balance;
        assertEq(userBalanceETH, 0 ether, "User shouldn't get their ETH back");

        uint256 userBalanceInVault = vault.balances(user);
        assertEq(userBalanceInVault, 0, "User shouldn't have balance in the vault");
    }
}