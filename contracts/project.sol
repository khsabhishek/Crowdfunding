// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import "./CrowdFunding.sol";

contract CreateProject {

    // Crowdfunding using crowdFunding;

    // Mapping to keep track of owners of the contract
    mapping(address => bool ) public owners;

    // Mapping to keep track of CrowdFunding contracts created by each owner
    mapping(address => address)public yourCrowdFundingAddress;

    // Modifier to restrict certain functions to contract owners only
    modifier onlyOwner {
        require(owners[msg.sender] == true);
        _;
    }

    // Constructor to add the deployer as the first owner of the contract
    constructor() {
        owners[msg.sender] = true;
    }

    // Function to create a new CrowdFunding contract
    function CreateCrowdFuncdingProject(
        uint256 _fundingGoal, 
        uint256 _durationDays,
        address _tokenAddress,
        address _projectOwner
        ) external onlyOwner returns(address) {
            // Check that the funding goal and duration are not zero
            require(_fundingGoal != 0 && _durationDays!= 0, "_fundingGoal and _durationDays cannot be zero");

            // Check that the token address is a contract and the project owner is not a zero address
            require(isContract(_tokenAddress) == true && _projectOwner != address(0), "_tokenAddress should be a contract address and _projectOwner should not be zero address");
            
            // Check if the owner already has a CrowdFunding contract and if it has not expired
            if(yourCrowdFundingAddress[msg.sender] != address(0) ) {
                require(Crowdfunding(yourCrowdFundingAddress[_projectOwner]).deadline() < block.timestamp , "msg.sender already has Crowdfunding contract and it havent expired");
            }

            // Create a new CrowdFunding contract
            Crowdfunding crowdFuncding = new Crowdfunding(
                _fundingGoal,
                _durationDays,
                _tokenAddress,
                _projectOwner
            );

            // Store the CrowdFunding contract address for the project owner
            yourCrowdFundingAddress[_projectOwner] = address(crowdFuncding);

            return address(crowdFuncding);
        }

    // Function to add new owners
    function addOwners(address _owner) external onlyOwner {
        require(_owner != address(0), "input address cannot be zero address");
        owners[msg.sender] = true;
    }

    // Function to remove owners
    function removeOwner(address _owner) external onlyOwner {
         require(_owner != address(0), "input address cannot be zero address");
        owners[msg.sender] = false;
    }

    // Function to check if an address is a contract
    function isContract(address addr) internal view returns (bool) {
    uint size;
    assembly {
        size := extcodesize(addr)
    }
    return size > 0;
    }

}