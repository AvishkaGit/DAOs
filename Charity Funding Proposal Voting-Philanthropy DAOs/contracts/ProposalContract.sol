// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ProposalContract {
    struct Proposal {
        uint id;
        address proposer;
        string description;
        uint amount;
        bool approved;
        uint votesFor;
        uint votesAgainst;
        mapping(address => bool) voters;
    }

    Proposal[] public proposals;
    uint public nextProposalId;

    event ProposalSubmitted(uint id, address indexed proposer, string description);
    event Voted(uint indexed proposalId, address indexed voter, bool support);
    event ProposalApproved(uint indexed proposalId);

    function submitProposal(string memory description, uint amount) external {
        uint proposalId = nextProposalId++;
        proposals.push(Proposal({
            id: proposalId,
            proposer: msg.sender,
            description: description,
            amount: amount,
            approved: false,
            votesFor: 0,
            votesAgainst: 0
        }));
        emit ProposalSubmitted(proposalId, msg.sender, description);
    }

    function vote(uint proposalId, bool support) external {
        Proposal storage proposal = proposals[proposalId];
        require(!proposal.voters[msg.sender], "Already voted");
        proposal.voters[msg.sender] = true;

        if (support) {
            proposal.votesFor++;
        } else {
            proposal.votesAgainst++;
        }

        emit Voted(proposalId, msg.sender, support);

        // Check if proposal is approved based on simple majority voting
        if (proposal.votesFor > proposal.votesAgainst) {
            proposal.approved = true;
            emit ProposalApproved(proposalId);
        }
    }

    function isApproved(uint proposalId) external view returns (bool) {
        return proposals[proposalId].approved;
    }

    function getAmount(uint proposalId) external view returns (uint) {
        return proposals[proposalId].amount;
    }

    function getProposal(uint proposalId) external view returns (uint, address, string memory, uint, bool, uint, uint) {
        Proposal memory proposal = proposals[proposalId];
        return (proposal.id, proposal.proposer, proposal.description, proposal.amount, proposal.approved, proposal.votesFor, proposal.votesAgainst);
    }

    function getProposalsCount() external view returns (uint) {
        return proposals.length;
    }
}
