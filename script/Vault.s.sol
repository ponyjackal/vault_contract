// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import { Script } from "forge-std/Script.sol";
import { Vault } from "../src/Vault.sol";
import "forge-std/console.sol";

/// @dev See the Solidity Scripting tutorial: https://book.getfoundry.sh/tutorials/solidity-scripting
contract DeployVault is Script {
    UUPSProxy proxy;
    Vault internal vault;

    function run() public {
        vm.startBroadcast();

        vault = new Vault();

        vm.stopBroadcast();
    }
}
