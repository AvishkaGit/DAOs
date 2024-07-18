// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RealEstate {
    struct Property {
        uint256 id;
        string name;
        string location;
        uint256 value; // Value of the property in wei (can be adjusted as needed)
        address owner;
        bool isAvailable;
    }
    
    Property[] public properties;
    mapping(uint256 => address) public propertyOwners;
    
    function addProperty(string memory _name, string memory _location, uint256 _value) external {
        uint256 newPropertyId = properties.length;
        properties.push(Property(newPropertyId, _name, _location, _value, msg.sender, true));
        propertyOwners[newPropertyId] = msg.sender;
    }
    
    function getProperty(uint256 _propertyId) external view returns (
        string memory name,
        string memory location,
        uint256 value,
        address owner,
        bool isAvailable
    ) {
        require(_propertyId < properties.length, "Property ID does not exist");
        Property memory property = properties[_propertyId];
        return (property.name, property.location, property.value, property.owner, property.isAvailable);
    }
    
    function buyProperty(uint256 _propertyId) external payable {
        require(propertyOwners[_propertyId] != address(0), "Property does not exist");
        require(properties[_propertyId].isAvailable, "Property is not available");
        require(msg.value >= properties[_propertyId].value, "Insufficient funds");
        
        address payable currentOwner = payable(propertyOwners[_propertyId]);
        currentOwner.transfer(msg.value);
        
        properties[_propertyId].owner = msg.sender;
        properties[_propertyId].isAvailable = false;
        propertyOwners[_propertyId] = msg.sender;
    }
}


