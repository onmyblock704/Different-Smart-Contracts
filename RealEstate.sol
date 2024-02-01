// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";

// Real estate contract for buying and selling properties
contract RealEstate {
    using SafeMath for uint256;

// Property struct to store information about a property
    struct Property {
        uint256 price;     // Price of the property
        address owner;     // Owner of the property
        bool forSale;      // Is the property for sale?
        string name;       // Name of the property
        string description;  // Description of the property
        string location;   // Location of the property
    }

    // Mapping from property IDs to property structs
    mapping(uint256 => Property) public properties;


    uint256[] public propertyIds;


    event PropertySold(uint256 propertyId);


    function listPropertyForSale(uint256 _propertyId, uint256 _price, string memory _name, string memory _description, string memory
    _location) public {

        Property memory newProperty = Property({
            price: _price,
            owner: msg.sender,
            forSale: true,
            name: _name,
            description: _description,
            location: _location
        });

    
        properties[_propertyId] = newProperty;
        propertyIds.push(_propertyId);
    }

    function buyProperty(uint256 _propertyId) public payable {

        Property storage property = properties[_propertyId];


       require(property.forSale, "Property is not for sale");
       require(property.price <= msg.value, "Insufficient funds");


       property.owner = msg.sender;
       property.forSale = false;


       payable(property.owner).transfer(property.price); 

       emit PropertySold(_propertyId); 
    }}