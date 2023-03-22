// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import "./TestToken.sol";
import "./modifiers.sol";

contract Crowdfunding is modifiers{
    TestToken public token;
    uint256 public fundingGoal;
    uint256 public deadline;
    address public projectOwner;
    uint256 public amountRaised;

    mapping(address => uint256) public balanceOf;
    mapping(address => bool) public hasPledged;
    mapping(address => bool) public hasWithdrawn;

    event GoalReached(address recipient, uint256 totalAmountRaised);
    event Pledge(address backer, uint256 amount);
    event Withdrawal(address backer, uint256 amount);

    constructor(
        uint256 _fundingGoal,
        uint256 _durationDays,
        address _tokenAddress,
        address _projectOwner
    ) CrowdFundingProject {
        fundingGoal = _fundingGoal;
        deadline = block.timestamp + (_durationDays * 1 days);
        token = TestToken(_tokenAddress);
        projectOwner = _projectOwner;
    }

    function pledge(uint256 _value) external {
        require(!hasWithdrawn[msg.sender], "You have already withdrawn your pledge");
        require(!hasPledged[msg.sender], "You have already pledged");
        require(token.transferFrom(msg.sender, address(this), _value), "Token transfer failed");
        balanceOf[msg.sender] += _value;
        amountRaised += _value;
        hasPledged[msg.sender] = true;
        emit Pledge(msg.sender, _value);

        if (amountRaised >= fundingGoal) {
            emit GoalReached(projectOwner, amountRaised);
        }
    }

    function withdraw() external {
        require(hasPledged[msg.sender], "You have not pledged");
        require(!hasWithdrawn[msg.sender], "You have already withdrawn your pledge");
        require(block.timestamp >= deadline, "Campaign is still ongoing");
        hasWithdrawn[msg.sender] = true;
        uint256 pledgeAmount = balanceOf[msg.sender];
        token.transfer(msg.sender, pledgeAmount);
        emit Withdrawal(msg.sender, pledgeAmount);
    }

    function claimFunds() external {
        require(projectOwner == msg.sender, "Only the project owner can claim funds");
        require(amountRaised >= fundingGoal, "Funding goal not reached");
        uint256 totalAmountRaised = amountRaised;
        amountRaised = 0;
        token.transfer(projectOwner, totalAmountRaised);
        emit GoalReached(projectOwner, totalAmountRaised);
    }

    function refund() external {
        require(hasPledged[msg.sender], "You have not pledged");
        require(!hasWithdrawn[msg.sender], "You have already withdrawn your pledge");
        require(block.timestamp >= deadline, "Campaign is still ongoing");
        hasWithdrawn[msg.sender] = true;
        uint256 pledgeAmount = balanceOf[msg.sender];
        token.transfer(msg.sender, pledgeAmount);
        emit Withdrawal(msg.sender, pledgeAmount);
    }
}
