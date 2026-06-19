// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract AuditRegistry {
    struct AuditReport {
        address auditor;
        string reportHash;
        string ipfsPointer;
        uint256 timestamp;
    }

    mapping(uint256 => AuditReport) public audits;
    uint256 public nextAuditId;

    event AuditStored(uint256 indexed auditId, address indexed auditor, string reportHash, string ipfsPointer);

    function storeAudit(string calldata reportHash, string calldata ipfsPointer) external returns (uint256) {
        require(bytes(reportHash).length > 0, "Invalid hash");
        require(bytes(ipfsPointer).length > 0, "Invalid IPFS pointer");

        uint256 auditId = nextAuditId++;
        audits[auditId] = AuditReport({
            auditor: msg.sender,
            reportHash: reportHash,
            ipfsPointer: ipfsPointer,
            timestamp: block.timestamp
        });

        emit AuditStored(auditId, msg.sender, reportHash, ipfsPointer);
        return auditId;
    }

    function verifyAudit(uint256 auditId, string calldata reportHash) external view returns (bool) {
        require(auditId < nextAuditId, "Invalid audit ID");
        return keccak256(abi.encodePacked(audits[auditId].reportHash)) == keccak256(abi.encodePacked(reportHash));
    }

    function getAudit(uint256 auditId) external view returns (address, string memory, string memory, uint256) {
        require(auditId < nextAuditId, "Invalid audit ID");
        AuditReport memory audit = audits[auditId];
        return (audit.auditor, audit.reportHash, audit.ipfsPointer, audit.timestamp);
    }
}
