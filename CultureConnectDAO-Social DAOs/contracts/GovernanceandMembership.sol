// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CultureConnectDAO {
    address public admin;
    uint256 public totalMembers;
    mapping(address => bool) public members;

    constructor() {
        admin = msg.sender;
        members[msg.sender] = true;
        totalMembers = 1;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    modifier onlyMember() {
        require(members[msg.sender], "Only members can perform this action");
        _;
    }

    function addMember(address _member) external onlyAdmin {
        require(!members[_member], "Member already exists");
        members[_member] = true;
        totalMembers++;
    }

    function removeMember(address _member) external onlyAdmin {
        require(members[_member], "Member does not exist");
        require(_member != admin, "Cannot remove admin");
        members[_member] = false;
        totalMembers--;
    }
    
    // Additional governance functions can be added here
}
