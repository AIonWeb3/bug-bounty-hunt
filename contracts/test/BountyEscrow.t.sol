// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../src/BountyEscrow.sol";
import "../src/Reputation.sol";

contract BountyEscrowTest is Test {
    BountyEscrow public escrow;
    Reputation public reputation;

    address creator = address(0x1);
    address submitter = address(0x2);

    function setUp() public {
        reputation = new Reputation();
        escrow = new BountyEscrow(address(reputation));
        reputation.setTrustedCaller(address(escrow));
    }

    function test_CreateBounty() public {
        vm.deal(creator, 1 ether);
        vm.prank(creator);
        uint256 bountyId = escrow.createBounty{value: 1 ether}();
        assertEq(bountyId, 0);

        (address c, uint256 reward, bool isActive) = escrow.bounties(0);
        assertEq(c, creator);
        assertEq(reward, 1 ether);
        assertTrue(isActive);
    }

    function test_SubmitAndApproveFinding() public {
        vm.deal(creator, 1 ether);
        vm.prank(creator);
        uint256 bountyId = escrow.createBounty{value: 1 ether}();

        vm.prank(submitter);
        escrow.submitFinding(bountyId, "hash123");

        (address sub, string memory hash, bool isApproved) = escrow.bountyFindings(bountyId, 0);
        assertEq(sub, submitter);
        assertEq(hash, "hash123");
        assertFalse(isApproved);

        vm.prank(creator);
        escrow.approveFinding(bountyId, 0);

        (, , bool isApprovedNow) = escrow.bountyFindings(bountyId, 0);
        assertTrue(isApprovedNow);
    }

    function test_ReleaseReward() public {
        vm.deal(creator, 1 ether);
        vm.prank(creator);
        uint256 bountyId = escrow.createBounty{value: 1 ether}();

        vm.prank(submitter);
        escrow.submitFinding(bountyId, "hash123");

        vm.prank(creator);
        escrow.approveFinding(bountyId, 0);

        uint256 balanceBefore = submitter.balance;
        escrow.releaseReward(bountyId, 0);
        uint256 balanceAfter = submitter.balance;

        assertEq(balanceAfter - balanceBefore, 1 ether);
        assertEq(reputation.getReputation(submitter), 10);
        
        (, , bool isActive) = escrow.bounties(bountyId);
        assertFalse(isActive);
    }

    function test_RevertIfReentrant() public {
        // Need to test reentrancy guard. We can simulate a malicious contract.
        MaliciousSubmitter attacker = new MaliciousSubmitter(address(escrow));
        
        vm.deal(creator, 1 ether);
        vm.prank(creator);
        uint256 bountyId = escrow.createBounty{value: 1 ether}();

        attacker.submit(bountyId, "hash123");

        vm.prank(creator);
        escrow.approveFinding(bountyId, 0);

        // This will revert during the execution of releaseReward because 
        // the malicious submitter tries to call releaseReward again inside its receive().
        vm.expectRevert("ReentrancyGuard: reentrant call");
        escrow.releaseReward(bountyId, 0);
    }
}

contract MaliciousSubmitter {
    BountyEscrow escrow;
    uint256 targetBountyId;

    constructor(address _escrow) {
        escrow = BountyEscrow(_escrow);
    }

    function submit(uint256 bountyId, string calldata hash) external {
        targetBountyId = bountyId;
        escrow.submitFinding(bountyId, hash);
    }

    receive() external payable {
        // Attempt reentrancy
        escrow.releaseReward(targetBountyId, 0);
    }
}
