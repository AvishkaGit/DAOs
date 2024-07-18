// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VotingContract {
    struct Vote {
        address voter;
        bool support; // true for yes, false for no
    }

    mapping(uint => uint) public votesFor;
    mapping(uint => uint) public votesAgainst;
    mapping(uint => mapping(address => bool)) public hasVoted;

    event Voted(uint indexed proposalId, address indexed voter, bool support);

    function vote(uint proposalId, bool support) external {
        require(!hasVoted[proposalId][msg.sender], "Already voted");

        if (support) {
            votesFor[proposalId]++;
        } else {
            votesAgainst[proposalId]++;
        }

        hasVoted[proposalId][msg.sender] = true;
        emit Voted(proposalId, msg.sender, support);
    }

    function getVoteCount(uint proposalId) external view returns (uint, uint) {
        return (votesFor[proposalId], votesAgainst[proposalId]);
    }
}
