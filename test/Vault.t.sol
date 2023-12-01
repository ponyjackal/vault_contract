// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import "forge-std/Test.sol";
import { console2 } from "forge-std/console2.sol";
import { PRBTest } from "@prb/test/PRBTest.sol";
import { StdCheats } from "forge-std/StdCheats.sol";
import { Vault } from "../src/Vault.sol";
import { MockToken } from "../src/MockToken.sol";

/// @dev See the "Writing Tests" section in the Foundry Book if this is your first time with Forge.
/// https://book.getfoundry.sh/forge/writing-tests
contract VaultTest is Test {
    Vault private vault;
    MockToken private token;

    address private admin;
    address private user;

    function setUp() public {
        admin = address(this);
        user = address(1);

        // Deploy the Vault contract
        vault = new Vault();

        // Deploy a mock ERC20 token
        token = new MockToken("Test Token", "TT");

        // Whitelist the token in the vault
        vault.whitelistToken(address(token), true);

        // Give some tokens to the user for testing
        token.mint(user, 1000 ether);
    }

    function testDeposit() public {
        uint256 depositAmount = 100 ether;

        // Approve and deposit tokens to the vault from the user's address
        vm.prank(user);
        token.approve(address(vault), depositAmount);
        vm.prank(user);
        vault.deposit(address(token), depositAmount);

        // Check if the tokens were deposited correctly
        assertEq(token.balanceOf(address(vault)), depositAmount);
    }

    function testWithdraw() public {
        uint256 depositAmount = 100 ether;
        uint256 withdrawAmount = 50 ether;

        // Deposit some tokens first
        vm.prank(user);
        token.approve(address(vault), depositAmount);
        vm.prank(user);
        vault.deposit(address(token), depositAmount);

        // Withdraw some of the deposited tokens
        vm.prank(user);
        vault.withdraw(address(token), withdrawAmount);

        // Check balances after withdrawal
        assertEq(token.balanceOf(address(vault)), depositAmount - withdrawAmount);
        assertEq(token.balanceOf(user), 1000 ether - depositAmount + withdrawAmount);
    }

    function testPauseAndUnpause() public {
        // Pause the vault
        vault.pause();

        // Attempt to deposit while paused (should revert)
        vm.expectRevert("Pausable: paused");
        vm.prank(user);
        vault.deposit(address(token), 10 ether);

        // Unpause the vault
        vault.unpause();

        // Attempt to deposit after unpausing (should succeed)
        vm.prank(user);
        token.approve(address(vault), 10 ether);
        vm.prank(user);
        vault.deposit(address(token), 10 ether);
    }

    function testNonWhitelistedTokenRejection() public {
        MockToken nonWhitelistedToken = new MockToken("Non Whitelisted Token", "NWT");

        // Attempt to deposit a non-whitelisted token (should revert)
        vm.expectRevert("Token not whitelisted");
        vm.prank(user);
        vault.deposit(address(nonWhitelistedToken), 10 ether);
    }
}
