// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../src/AuditRegistry.sol";

contract AuditRegistryTest is Test {
    AuditRegistry public registry;

    function setUp() public {
        registry = new AuditRegistry();
    }

    function test_StoreAudit() public {
        vm.prank(address(0x1));
        uint256 id = registry.storeAudit("hash123", "ipfs://pointer");
        assertEq(id, 0);

        (address auditor, string memory hash, string memory ipfs, uint256 timestamp) = registry.getAudit(0);
        assertEq(auditor, address(0x1));
        assertEq(hash, "hash123");
        assertEq(ipfs, "ipfs://pointer");
        assertGt(timestamp, 0);
    }

    function test_VerifyAudit() public {
        vm.prank(address(0x1));
        uint256 id = registry.storeAudit("hash123", "ipfs://pointer");

        assertTrue(registry.verifyAudit(id, "hash123"));
        assertFalse(registry.verifyAudit(id, "wronghash"));
    }
}
