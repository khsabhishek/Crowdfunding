// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import "./CrowdFunding.sol";
import "./modifiers.sol";

contract CreateProject is modifiers {

    // Crowdfunding using crowdFunding;

    // mapping(address => bool ) public owners;

    // modifier onlyOwner {
    //     require(owners[msg.sender] == true);
    //     _;
    // }

    constructor() {
        owners[msg.sender] = true;
        mainCrowdFundingProject = address(this);
    }

    function CreateCrowdFuncdingProject(
        uint256 _fundingGoal, 
        uint256 _durationDays,
        address _tokenAddress,
        address _projectOwner
        ) external onlyOwner returns(address) {
        Crowdfunding crowdFuncding = new Crowdfunding(
            _fundingGoal,
            _durationDays,
            _tokenAddress,
            _projectOwner
        );

        return address(crowdFuncding);
    }

    function addOwners(address _owner) external onlyOwner {
        require(_owner != address(0), "input address cannot be zero address");
        owners[msg.sender] = true;
    }

    function removeOwner(address _owner) external onlyOwner {
         require(_owner != address(0), "input address cannot be zero address");
        owners[msg.sender] = false;
    }
}