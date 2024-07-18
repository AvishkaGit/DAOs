// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ProposalContract {
    struct Proposal {
        uint id;
        address proposer;
        string description;
        bytes data;
        uint votesFor;
        uint votesAgainst;
        bool executed;
    }

    Proposal[] public proposals;
    uint public nextProposalId;

    event ProposalSubmitted(uint id, address indexed proposer, string description);

    function submitProposal(string memory description, bytes memory proposalData) external {
        uint proposalId = nextProposalId++;
        proposals.push(Proposal({
            id: proposalId,
            proposer: msg.sender,
            description: description,
            data: proposalData,
            votesFor: 0,
            votesAgainst: 0,
            executed: false
        }));
        emit ProposalSubmitted(proposalId, msg.sender, description);
    }

    function getProposal(uint proposalId) external view returns (Proposal memory) {
        require(proposalId < nextProposalId, "Proposal does not exist");
        return proposals[proposalId];
    }

    function getProposalsCount() external view returns (uint) {
        return proposals.length;
    }
}
