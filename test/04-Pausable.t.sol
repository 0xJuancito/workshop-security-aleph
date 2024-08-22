// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Vault} from "../src/04-Pausable.sol";

contract PausableTest is Test {
    address owner;
    Vault public vault;

    function setUp() public {
        owner = makeAddr("OWNER");

        vm.prank(owner);
        vault = new Vault();

        address user = makeAddr("USER");
        hoax(user);
        vault.deposit{value: 10 ether}();
    }

    function test_Pausable() public {
        address attacker = makeAddr("ATTACKER");
        vm.deal(attacker, 1 ether);

        vm.startPrank(owner);

        // START OF SOLUTION
        
        // The attacker is preparing the attack. We need to stop it before it is too late
        // Sadly we didn't implement the pausing mechanism appropiately
        // Task: Add the missing functionality to `04-Pausable` and pause the contract here

        // END OF SOLUTION

        vm.stopPrank();

        assertTrue(vault.paused());

        vm.startPrank(attacker);

        vm.expectRevert();
        (bool ok,) = address(vault).call(abi.encodeWithSignature("unpause()"));
        assertEq(ok, false, "Attacker shouldn't be able to unpause the vault");

        vm.expectRevert();
        vault.withdraw();
    }
}
