// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Vault} from "../src/05-Distributor.sol";

contract DistributorTest is Test {
    address owner;
    address user;
    Vault public vault;

    function setUp() public {
        owner = makeAddr("OWNER");
        vm.prank(owner);
        vault = new Vault();

        user = makeAddr("USER");
        vm.deal(user, 10 ether);
        vm.prank(user);
        vault.deposit{value: 10 ether}();
    }

    function test_Distributor() public {
        address attacker = makeAddr("ATTACKER");
        vm.deal(attacker, 1 ether);

        vm.startPrank(attacker);

        // START OF SOLUTION
        // (You can create any additional contract if needed)

        

        // END OF SOLUTION

        vm.stopPrank();

        vm.prank(owner);

        vm.expectRevert();
        vault.distribute();

        uint256 userBalance = address(user).balance;
        assertEq(userBalance, 0, "User shouldn't receive their ETH back");

        uint256 vaultBalance = address(vault).balance;
        assertGe(vaultBalance, 10 ether, "Vault ETH should be stuck");
    }
}
