// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import "./TestToken.sol";

contract Crowdfunding {
    TestToken public token; // Instance of the TestToken contract 
    uint256 public fundingGoal; // Funding goal for the campaign
    uint256 public deadline; // Unix timestamp for the end of the campaign
    address public projectOwner; // Address of the project owner
    uint256 public amountRaised; // Total amount raised so far

    mapping(address => uint256) public balanceOf; // Maps a backer's address to their pledge balance
    mapping(address => bool) public hasPledged; // Maps a backer's address to whether or not they have pledged
    mapping(address => bool) public hasWithdrawn; // Maps a backer's address to whether or not they have withdrawn their pledge

    event GoalReached(address recipient, uint256 totalAmountRaised); // Event fired when the funding goal is reached
    event Pledge(address backer, uint256 amount); // Event fired when a backer pledges funds
    event Withdrawal(address backer, uint256 amount); // Event fired when a backer withdraws their pledge

    constructor(
        uint256 _fundingGoal, // Funding goal for the campaign
        uint256 _durationDays, // Duration of the campaign in days
        address _tokenAddress, // Address of the token contract to be used for pledges
        address _projectOwner // Address of the project owner
    ) {
        fundingGoal = _fundingGoal;
        deadline = block.timestamp + (_durationDays * 1 days);
        token = TestToken(_tokenAddress);
        projectOwner = _projectOwner;
    }

    // Function for backers to pledge funds to the campaign
    function pledge(uint256 _value) external {
        // Check that the backer has not already withdrawn their pledge
        require(!hasWithdrawn[msg.sender], "You have already withdrawn your pledge");

        // Check that the backer has not already pledged
        require(!hasPledged[msg.sender], "You have already pledged");

        // Transfer the pledge amount from the backer to the contract
        require(token.transferFrom(msg.sender, address(this), _value), "Token transfer failed");

        // Update the backer's pledge balance and the total amount raised
        balanceOf[msg.sender] += _value;
        amountRaised += _value;

        // Mark the backer as having pledged
        hasPledged[msg.sender] = true;

        // Emit the Pledge event
        emit Pledge(msg.sender, _value);

        // Check if the funding goal has been reached, and if so, emit the GoalReached event
        if (amountRaised >= fundingGoal) {
            emit GoalReached(projectOwner, amountRaised);
        }
    }

    // Function for backers to withdraw their pledge if the campaign is unsuccessful
    function withdraw() external {
        // Check if the sender has pledged
        require(hasPledged[msg.sender], "You have not pledged");

        // Check if the sender has already withdrawn their pledge
        require(!hasWithdrawn[msg.sender], "You have already withdrawn your pledge");

        // Check if the sender has already withdrawn their pledge
        require(block.timestamp >= deadline, "Campaign is still ongoing");

         // Mark the sender as having withdrawn their pledge
        hasWithdrawn[msg.sender] = true;

        // Get the sender's pledged amount
        uint256 pledgeAmount = balanceOf[msg.sender];

        // Transfer the pledged amount back to the sender
        token.transfer(msg.sender, pledgeAmount);

        // Emit the Withdrawal event
        emit Withdrawal(msg.sender, pledgeAmount);
    }

    function claimFunds() external {
        // Check if the sender is the project owner
        require(projectOwner == msg.sender, "Only the project owner can claim funds");

        // Check if the funding goal has been reached
        require(amountRaised >= fundingGoal, "Funding goal not reached");

        // Store amountRaised to a variable and make amountRaised it zero
        uint256 totalAmountRaised = amountRaised;
        amountRaised = 0;

        // Transfer totalAmountRaised to projectOwner
        token.transfer(projectOwner, totalAmountRaised);

        // Emit the GoalReached event
        emit GoalReached(projectOwner, totalAmountRaised);
    }

    function refund() external {
        // Check if sender have pledged 
        require(hasPledged[msg.sender], "You have not pledged");

        // check if sender have withdrawed
        require(!hasWithdrawn[msg.sender], "You have already withdrawn your pledge");

        //check if current timestamp is greater then deadline timestamp
        require(block.timestamp >= deadline, "Campaign is still ongoing");

        // make hasWithdrawn of sender true
        hasWithdrawn[msg.sender] = true;

        // store balance of sender is a variable
        uint256 pledgeAmount = balanceOf[msg.sender];

        // Transfer tokens to sender
        token.transfer(msg.sender, pledgeAmount);
        
        // Emit Withdrawal event
        emit Withdrawal(msg.sender, pledgeAmount);
    }
}
