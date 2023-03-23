## Crowdfunding.sol
This is a smart contract written in Solidity for a crowdfunding campaign. The contract allows backers to pledge funds to a campaign using a specific ERC20 token, and allows the project owner to claim the funds if the funding goal is reached before the campaign deadline. If the funding goal is not reached before the deadline, backers can withdraw their pledged funds.

Features
The smart contract has the following features:

Backers can pledge funds to the campaign using a specific ERC20 token.
Backers can withdraw their pledged funds if the funding goal is not reached before the campaign deadline.
The project owner can claim the funds if the funding goal is reached before the campaign deadline.
The contract emits events for pledges, withdrawals, and the funding goal being reached.
The contract includes safety checks to prevent multiple pledges or withdrawals and to ensure that the campaign deadline has passed before allowing withdrawals or fund claims.
Dependencies
The contract depends on the following Solidity contract:

TestToken.sol: This is an ERC20 token contract that is used for pledges. It must be deployed and its address passed to the constructor of the crowdfunding contract.

## project.sol
This is a Solidity smart contract named CreateProject which allows owners to create new crowdfunding projects using the CrowdFunding contract.

The contract includes the following features:

A mapping to keep track of owners of the contract.
A mapping to keep track of CrowdFunding contracts created by each owner.
A modifier to restrict certain functions to contract owners only.
A constructor to add the deployer as the first owner of the contract.
A function to create a new CrowdFunding contract.
A function to add new owners.
A function to remove owners.
A function to check if an address is a contract.
The CreateCrowdFuncdingProject function allows owners to create new crowdfunding projects by specifying the funding goal, duration in days, token address, and project owner. It checks that the funding goal and duration are not zero and that the token address is a contract and the project owner is not a zero address. It also checks if the owner already has a CrowdFunding contract and if it has not expired.

The addOwners function allows owners to add new owners to the contract, while the removeOwner function allows owners to remove owners from the contract. These functions check that the input address is not a zero address.

The isContract function is an internal function that checks if an address is a contract by using the extcodesize opcode.

This contract can be used as a factory contract to create multiple crowdfunding projects.
