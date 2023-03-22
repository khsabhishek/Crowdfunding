// SPDX-License-Identifier: MIT
pragma solidity  0.8.18;

contract modifiers {
    mapping(address => bool ) public owners;

    modifier onlyOwner {
        require(owners[msg.sender] == true);
        _;
    }
}