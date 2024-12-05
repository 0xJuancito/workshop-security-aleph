// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Vault, Attacker} from "../src/03-Flashloan.sol";

contract CallerTest is Test {
    Vault public vault;
    Attacker public attackerContract;

    function setUp() public {
        vault = new Vault();
        attackerContract = new Attacker(address(vault));

        address user = makeAddr("USER");
        hoax(user);
        vault.deposit{value: 10 ether}();
    }

    function test_Flashloan() public {
        // START OF SOLUTION
        // (You can create any additional contract if needed)
        vm.deal(address(attackerContract), 1 ether);
        attackerContract.attack();
        attackerContract.withdraw();
        

        // END OF SOLUTION

        uint256 vaultBalance = address(vault).balance;
        assertEq(vaultBalance, 0, "Vault still has balance");

        uint256 attackerBalance = address(attackerContract).balance;
        assertEq(attackerBalance, 11 ether, "Attacker didn't get the assets");
    }
}
