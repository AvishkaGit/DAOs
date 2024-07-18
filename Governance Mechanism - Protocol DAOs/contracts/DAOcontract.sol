// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./contracts/ProposalContract.sol";
import "./contracts/VotingContract.sol";

contract DAO {
    ProposalContract public proposalContract;
    VotingContract public votingContract;

    constructor() {
        proposalContract = new ProposalContract();
        votingContract = new VotingContract();
    }

    function submitProposal(string memory description, bytes memory proposalData) external {
        proposalContract.submitProposal(description, proposalData);
    }

    function vote(uint proposalId, bool support) external {
        votingContract.vote(proposalId, support);
    }

    function getProposal(uint proposalId) external view returns (ProposalContract.Proposal memory) {
        return proposalContract.getProposal(proposalId);
    }

    function getProposalsCount() external view returns (uint) {
        return proposalContract.getProposalsCount();
    }

    function getVoteCount(uint proposalId) external view returns (uint, uint) {
        return votingContract.getVoteCount(proposalId);
    }
}
