// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.12;

import { Pausable } from "@openzeppelin/contracts/security/Pausable.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { AccessControl } from "@openzeppelin/contracts/access/AccessControl.sol";

contract Vault is Pausable, Ownable, AccessControl {
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    mapping(address => bool) private whitelistedTokens;

    constructor() {
        // Set the deployer as the default admin
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(ADMIN_ROLE, msg.sender);
    }

    /** Modifiers */
    modifier onlyAdmin() {
        require(hasRole(ADMIN_ROLE, msg.sender), "Caller is not an admin");
        _;
    }

    /** Mutate functions */

    /**
     * Allows users to deposit ERC20 tokens into the vault.
     * The contract must not be paused, and the token must be whitelisted.
     * @param token The address of the ERC20 token to deposit.
     * @param amount The amount of tokens to deposit.
     */
    function deposit(address token, uint256 amount) external whenNotPaused {
        require(whitelistedTokens[token], "Token not whitelisted");
        IERC20(token).transferFrom(msg.sender, address(this), amount);
    }

    /**
     * Allows users to withdraw ERC20 tokens from the vault.
     * The contract must not be paused, and the token must be whitelisted.
     * @param token The address of the ERC20 token to withdraw.
     * @param amount The amount of tokens to withdraw.
     */
    function withdraw(address token, uint256 amount) external whenNotPaused {
        require(whitelistedTokens[token], "Token not whitelisted");
        IERC20(token).transfer(msg.sender, amount);
    }

    /** Admin functions */
    /**
     * Pauses the contract, disabling the deposit and withdraw functions.
     * Can only be called by an account with the ADMIN_ROLE.
     */
    function pause() external onlyAdmin {
        _pause();
    }

    /**
     * Unpauses the contract, enabling the deposit and withdraw functions.
     * Can only be called by an account with the ADMIN_ROLE.
     */
    function unpause() external onlyAdmin {
        _unpause();
    }

    /**
     * Allows an admin to add or remove a token from the whitelist.
     * @param token The address of the ERC20 token to whitelist.
     * @param status Boolean representing whether to add (true) or remove (false) the token from the whitelist.
     */
    function whitelistToken(address token, bool status) external onlyRole(ADMIN_ROLE) {
        whitelistedTokens[token] = status;
    }

    /**
     * Allows the contract owner to modify admin roles.
     * Can grant or revoke the ADMIN_ROLE from an account.
     * @param account The address of the account to modify admin privileges for.
     * @param isGrant Boolean indicating whether to grant (true) or revoke (false) the admin role.
     */
    function modifyAdminRole(address account, bool isGrant) public onlyRole(DEFAULT_ADMIN_ROLE) {
        if (isGrant) {
            grantRole(ADMIN_ROLE, account);
        } else {
            revokeRole(ADMIN_ROLE, account);
        }
    }
}
