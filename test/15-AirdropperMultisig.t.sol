// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Vault} from "../src/15-AirdropperMultisig.sol";

contract AirdropperMultisigTest is Test {
    Vault public vault;

    function setUp() public {
        address signer = makeAddr("SIGNER");
        vault = new Vault(signer);
    }

    function test_AirdropperMultisig() public {
        // What kind of attack is possible in `AirdropperMultisig.sol`?
        // How can we prevent it?
    }
}
