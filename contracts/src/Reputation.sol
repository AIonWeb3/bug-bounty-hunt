// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Reputation {
    mapping(address => uint256) public reputationScores;
    address public trustedCaller;

    event ReputationAdded(address indexed user, uint256 amount, uint256 newTotal);
    event ReputationRemoved(address indexed user, uint256 amount, uint256 newTotal);

    modifier onlyTrusted() {
        require(msg.sender == trustedCaller, "Caller is not trusted");
        _;
    }

    constructor() {
        trustedCaller = msg.sender;
    }

    function setTrustedCaller(address _trustedCaller) external onlyTrusted {
        trustedCaller = _trustedCaller;
    }

    function addReputation(address user, uint256 amount) external onlyTrusted {
        reputationScores[user] += amount;
        emit ReputationAdded(user, amount, reputationScores[user]);
    }

    function removeReputation(address user, uint256 amount) external onlyTrusted {
        if (reputationScores[user] < amount) {
            reputationScores[user] = 0;
        } else {
            reputationScores[user] -= amount;
        }
        emit ReputationRemoved(user, amount, reputationScores[user]);
    }

    function getReputation(address user) external view returns (uint256) {
        return reputationScores[user];
    }
}
