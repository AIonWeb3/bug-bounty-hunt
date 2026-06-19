// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./Reputation.sol";

contract BountyEscrow {
    struct Bounty {
        address creator;
        uint256 reward;
        bool isActive;
    }

    struct Finding {
        address submitter;
        string descriptionHash;
        bool isApproved;
    }

    mapping(uint256 => Bounty) public bounties;
    mapping(uint256 => Finding[]) public bountyFindings;
    uint256 public nextBountyId;

    Reputation public reputationContract;

    // Reentrancy Guard state
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;
    uint256 private _status;

    event BountyCreated(uint256 indexed bountyId, address indexed creator, uint256 reward);
    event FindingSubmitted(uint256 indexed bountyId, uint256 findingIndex, address indexed submitter, string descriptionHash);
    event FindingApproved(uint256 indexed bountyId, uint256 findingIndex);
    event RewardReleased(uint256 indexed bountyId, address indexed recipient, uint256 amount);
    event BountyCancelled(uint256 indexed bountyId);

    modifier nonReentrant() {
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
        _status = _ENTERED;
        _;
        _status = _NOT_ENTERED;
    }

    modifier onlyCreator(uint256 bountyId) {
        require(bounties[bountyId].creator == msg.sender, "Not bounty creator");
        _;
    }

    constructor(address _reputationContract) {
        reputationContract = Reputation(_reputationContract);
        _status = _NOT_ENTERED;
    }

    function createBounty() external payable returns (uint256) {
        require(msg.value > 0, "Reward must be > 0");
        
        uint256 bountyId = nextBountyId++;
        bounties[bountyId] = Bounty({
            creator: msg.sender,
            reward: msg.value,
            isActive: true
        });

        emit BountyCreated(bountyId, msg.sender, msg.value);
        return bountyId;
    }

    function submitFinding(uint256 bountyId, string calldata descriptionHash) external {
        require(bounties[bountyId].isActive, "Bounty is not active");
        require(bytes(descriptionHash).length > 0, "Invalid hash");

        bountyFindings[bountyId].push(Finding({
            submitter: msg.sender,
            descriptionHash: descriptionHash,
            isApproved: false
        }));

        emit FindingSubmitted(bountyId, bountyFindings[bountyId].length - 1, msg.sender, descriptionHash);
    }

    function approveFinding(uint256 bountyId, uint256 findingIndex) external onlyCreator(bountyId) {
        require(bounties[bountyId].isActive, "Bounty is not active");
        require(findingIndex < bountyFindings[bountyId].length, "Invalid finding index");
        require(!bountyFindings[bountyId][findingIndex].isApproved, "Finding already approved");

        bountyFindings[bountyId][findingIndex].isApproved = true;

        emit FindingApproved(bountyId, findingIndex);
    }

    function releaseReward(uint256 bountyId, uint256 findingIndex) external nonReentrant {
        Bounty storage bounty = bounties[bountyId];
        require(bounty.isActive, "Bounty not active");
        require(findingIndex < bountyFindings[bountyId].length, "Invalid finding index");
        
        Finding storage finding = bountyFindings[bountyId][findingIndex];
        require(finding.isApproved, "Finding not approved");

        // Checks
        uint256 rewardAmount = bounty.reward;
        address submitter = finding.submitter;

        // Effects
        bounty.isActive = false; // Mark as closed
        reputationContract.addReputation(submitter, 10); // Increase reputation on successful finding

        // Interactions
        (bool success, ) = payable(submitter).call{value: rewardAmount}("");
        require(success, "Transfer failed");

        emit RewardReleased(bountyId, submitter, rewardAmount);
    }

    function cancelBounty(uint256 bountyId) external onlyCreator(bountyId) nonReentrant {
        Bounty storage bounty = bounties[bountyId];
        require(bounty.isActive, "Bounty not active");

        // Effects
        uint256 amount = bounty.reward;
        bounty.isActive = false;

        // Interactions
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Refund failed");

        emit BountyCancelled(bountyId);
    }
}
