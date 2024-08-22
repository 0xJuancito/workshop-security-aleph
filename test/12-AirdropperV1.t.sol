// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Vault} from "../src/12-AirdropperV1.sol";

contract AirdropperV1Test is Test {
    address owner;
    address user;
    address attacker;
    bytes32 leftLeaf;
    bytes32 rightLeaf;
    Vault public vault;

    function setUp() public {
        owner = makeAddr("OWNER");
        user = makeAddr("USER");
        attacker = makeAddr("ATTACKER");

        leftLeaf = keccak256(abi.encodePacked(user));
        rightLeaf = keccak256(abi.encodePacked(attacker));

        // Calculate root
        bytes32 root = keccak256(
            abi.encode(leftLeaf, rightLeaf)
        );

        deal(owner, 2 ether);

        vm.startPrank(owner);
        vault = new Vault();
        vault.setMerkleRoot(root);
        vault.donate{value: 2 ether}();
        vm.stopPrank();
    }

    function test_AirdropperV1() public {
        vm.startPrank(attacker);

        // START OF SOLUTION
        // (You can create any additional contract if needed)

        

        // END OF SOLUTION

        vm.stopPrank();

        vm.startPrank(user);

        bytes32[] memory userProof = new bytes32[](1);
        userProof[0] = rightLeaf;
        vault.claim(user, 1 ether, type(uint96).max, userProof);
        vm.expectRevert();
        vault.withdraw(user, 1 ether);

        uint256 vaultBalance = address(vault).balance;
        assertEq(vaultBalance, 0, "Vault still has balance");

        uint256 userBalance = address(user).balance;
        assertEq(userBalance, 0, "User has balance");

        uint256 attackerBalance = address(attacker).balance;
        assertEq(attackerBalance, 2 ether, "Attacker didn't get the assets");
    }
}
