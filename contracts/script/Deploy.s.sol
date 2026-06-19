// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Script.sol";
import "../src/BountyEscrow.sol";
import "../src/Reputation.sol";
import "../src/AuditRegistry.sol";

contract DeployScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        Reputation reputation = new Reputation();
        BountyEscrow escrow = new BountyEscrow(address(reputation));
        reputation.setTrustedCaller(address(escrow));

        AuditRegistry registry = new AuditRegistry();

        vm.stopBroadcast();

        // Print deployed addresses
        console.log("Reputation deployed to:", address(reputation));
        console.log("BountyEscrow deployed to:", address(escrow));
        console.log("AuditRegistry deployed to:", address(registry));
    }
}
