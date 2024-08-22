// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Vault} from "../src/14-AirdropperForAll.sol";

contract AirdropperForAllTest is Test {
    Vault public vault;

    function setUp() public {
        vault = new Vault();
    }

    function test_AirdropperForAll() public {
        // What kind of attack is possible in `AirdropperForAll.sol`?
        // How can we prevent it?
    }
}