// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./contracts/CommunityGrantsDAO.sol";

contract ProposalSubmission {
    CommunityGrantsDAO public dao;

    struct Proposal {
        uint256 id;
        string description;
        address payable proposer;
        uint256 amount;
        uint256 votesFor;
        uint256 votesAgainst;
        bool executed;
        bool exists;
    }
    
    Proposal[] public proposals;
    mapping(uint256 => mapping(address => bool)) public votes;
    
    event ProposalCreated(uint256 id, string description, address proposer, uint256 amount);
    event VoteCast(uint256 id, address voter, bool support);
    event ProposalExecuted(uint256 id, bool success);
    
    constructor(address _daoAddress) {
        dao = CommunityGrantsDAO(_daoAddress);
    }
    
    modifier onlyMember() {
        require(dao.members(msg.sender), "Only members can perform this action");
        _;
    }
    
    function submitProposal(string memory _description, uint256 _amount) external onlyMember {
        uint256 newProposalId = proposals.length;
        proposals.push(Proposal(newProposalId, _description, payable(msg.sender), _amount, 0, 0, false, true));
        emit ProposalCreated(newProposalId, _description, msg.sender, _amount);
    }
    
    function voteOnProposal(uint256 _proposalId, bool support) external onlyMember {
        require(proposals[_proposalId].exists, "Proposal does not exist");
        require(!votes[_proposalId][msg.sender], "You have already voted on this proposal");
        
        votes[_proposalId][msg.sender] = true;
        
        if (support) {
            proposals[_proposalId].votesFor++;
        } else {
            proposals[_proposalId].votesAgainst++;
        }
        
        emit VoteCast(_proposalId, msg.sender, support);
    }
    
    function executeProposal(uint256 _proposalId) external onlyMember {
        Proposal storage proposal = proposals[_proposalId];
        require(proposal.exists, "Proposal does not exist");
        require(!proposal.executed, "Proposal has already been executed");
        require(proposal.votesFor > proposal.votesAgainst, "Proposal did not pass");
        
        proposal.executed = true;
        bool success = proposal.proposer.send(proposal.amount);
        emit ProposalExecuted(_proposalId, success);
    }
    
    function getProposal(uint256 _proposalId) external view returns (
        string memory description,
        address proposer,
        uint256 amount,
        uint256 votesFor,
        uint256 votesAgainst,
        bool executed
    ) {
        require(_proposalId < proposals.length, "Proposal ID does not exist");
        Proposal memory proposal = proposals[_proposalId];
        return (proposal.description, proposal.proposer, proposal.amount, proposal.votesFor, proposal.votesAgainst, proposal.executed);
    }
}
