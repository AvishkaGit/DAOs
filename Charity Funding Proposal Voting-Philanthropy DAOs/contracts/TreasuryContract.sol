// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TreasuryContract {
    mapping(uint => uint) public fundsAllocated;

    function allocateFunds(uint proposalId, uint amount) external {
        fundsAllocated[proposalId] += amount;
    }

    function getAllocatedFunds(uint proposalId) external view returns (uint) {
        return fundsAllocated[proposalId];
    }
}
