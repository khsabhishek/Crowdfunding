// SPDX-License-Identifier: MIT
pragma solidity  0.8.18;

contract modifiers {
    address public mainCrowdFundingProject;

    mapping(address => bool ) public owners;

    modifier onlyOwner {
        require(owners[msg.sender] == true);
        _;
    }

    modifier CrowdFundingProject {
        require(msg.sender == mainCrowdFundingProject);
        _;
    }

}