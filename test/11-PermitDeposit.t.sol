// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Vault, Permit} from "../src/11-PermitDeposit.sol";
import {IERC20} from "../lib/openzeppelin/token/ERC20/IERC20.sol";

contract PermitDepositTest is Test {
    address user;
    IERC20 usdc;
    IERC20 dai;
    IERC20 weth;
    Vault public vault;

    function setUp() public {
        vm.createSelectFork("https://ethereum-rpc.publicnode.com", 20580735);

        vault = new Vault();

        usdc = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
        dai = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);
        weth = IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);

        user = makeAddr("USER");
        deal(address(usdc), user, 200);
        deal(address(dai), user, 200);
        deal(address(weth), user, 200);

        vm.startPrank(user);
        usdc.approve(address(vault), type(uint256).max);
        vault.deposit(address(usdc), 100, user);

        dai.approve(address(vault), type(uint256).max);
        vault.deposit(address(dai), 100, user);

        weth.approve(address(vault), type(uint256).max);
        vault.deposit(address(weth), 100, user);
        vm.stopPrank();
    }

    function test_PermitDeposit() public {
        address attacker = makeAddr("ATTACKER");

        vm.startPrank(attacker);

        // START OF SOLUTION
        // (You can create any additional contract if needed)

        

        // END OF SOLUTION

        // The goal is to steal any of the tokens

        uint256 attackerBalanceUSDC = usdc.balanceOf(attacker);
        uint256 attackerBalanceDAI = dai.balanceOf(attacker);
        uint256 attackerBalanceWETH = weth.balanceOf(attacker);
        uint256 attackerBalanceTotal = attackerBalanceUSDC + attackerBalanceDAI + attackerBalanceWETH;
        assertGe(attackerBalanceTotal, 200, "Attacker didn't steal enough assets");
    }
}