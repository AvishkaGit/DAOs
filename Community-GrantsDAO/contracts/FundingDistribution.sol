// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./contracts/ProposalSubmission.sol";

contract FundingDistribution {
    ProposalSubmission public proposalSubmission;

    constructor(address _proposalSubmissionAddress) {
        proposalSubmission = ProposalSubmission(_proposalSubmissionAddress);
    }
    
    function depositFunds() external payable {}

    function distributeFunds(uint256 _proposalId) external {
        ProposalSubmission.Proposal memory proposal = proposalSubmission.getProposal(_proposalId);
        require(proposal.executed, "Proposal has not been executed yet");
        require(address(this).balance >= proposal.amount, "Insufficient funds in contract");
        
        proposal.proposer.transfer(proposal.amount);
    }
}
