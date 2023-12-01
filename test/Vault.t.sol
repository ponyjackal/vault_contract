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

    function testWithdrawMoreThanDeposit() public {
        // Set the amount to be deposited and the amount to be withdrawn.
        // The withdraw amount is intentionally set higher than the deposit amount to test the validation.
        uint256 depositAmount = 100 ether;
        uint256 withdrawAmount = 150 ether;

        // Simulate the user approving the Vault to spend their tokens.
        // This is necessary for the Vault to be able to pull tokens from the user's account.
        vm.prank(user);
        token.approve(address(vault), depositAmount);

        // Simulate the user depositing tokens into the Vault.
        // The user's balance in the Vault should now be equal to the deposit amount.
        vm.prank(user);
        vault.deposit(address(token), depositAmount);

        // Expect the next transaction to revert with a specific error message.
        // This is because the user is trying to withdraw more tokens than what they have deposited.
        vm.expectRevert("Insufficient balance");

        // Simulate the user attempting to withdraw more tokens than they have deposited.
        // The test expects this transaction to fail and revert.
        vm.prank(user);
        vault.withdraw(address(token), withdrawAmount);
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
