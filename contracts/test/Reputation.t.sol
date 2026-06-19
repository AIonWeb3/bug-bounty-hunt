// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../src/Reputation.sol";

contract ReputationTest is Test {
    Reputation public reputation;

    function setUp() public {
        reputation = new Reputation();
    }

    function test_AddReputation() public {
        reputation.addReputation(address(0x1), 10);
        assertEq(reputation.getReputation(address(0x1)), 10);
    }

    function test_RemoveReputation() public {
        reputation.addReputation(address(0x1), 10);
        reputation.removeReputation(address(0x1), 5);
        assertEq(reputation.getReputation(address(0x1)), 5);
        
        // Remove more than exists
        reputation.removeReputation(address(0x1), 10);
        assertEq(reputation.getReputation(address(0x1)), 0);
    }

    function test_RevertIfNotTrusted() public {
        vm.prank(address(0x2));
        vm.expectRevert("Caller is not trusted");
        reputation.addReputation(address(0x1), 10);
    }
}
