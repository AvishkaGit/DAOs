// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ProposalContract.sol";
import "./TreasuryContract.sol";

contract CharityDAO {
    ProposalContract public proposalContract;
    TreasuryContract public treasuryContract;

    constructor() {
        proposalContract = new ProposalContract();
        treasuryContract = new TreasuryContract();
    }

    function submitProposal(string memory description, uint amount) external {
        proposalContract.submitProposal(description, amount);
    }

    function vote(uint proposalId, bool support) external {
        proposalContract.vote(proposalId, support);
    }

    function allocateFunds(uint proposalId) external {
        require(proposalContract.isApproved(proposalId), "Proposal not approved");
        uint amount = proposalContract.getAmount(proposalId);
        treasuryContract.allocateFunds(proposalId, amount);
    }

    function getProposal(uint proposalId) external view returns (ProposalContract.Proposal memory) {
        return proposalContract.getProposal(proposalId);
    }

    function getProposalsCount() external view returns (uint) {
        return proposalContract.getProposalsCount();
    }

    function getAllocatedFunds(uint proposalId) external view returns (uint) {
        return treasuryContract.getAllocatedFunds(proposalId);
    }
}
