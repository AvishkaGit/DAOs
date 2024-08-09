// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./EventProposals.sol";

contract FundingTreasury {
    EventProposals public eventProposals;

    constructor(address _eventProposalsAddress) {
        eventProposals = EventProposals(_eventProposalsAddress);
    }

    function depositFunds() external payable {}

    function distributeFunds(uint256 _proposalId) external {
        EventProposals.Proposal memory proposal = eventProposals.getProposal(_proposalId);
        require(proposal.executed, "Proposal has not been executed yet");
        require(address(this).balance >= proposal.fundingRequest, "Insufficient funds in contract");

        (bool success, ) = proposal.proposer.call{value: proposal.fundingRequest}("");
        require(success, "Funding transfer failed");
    }
}
