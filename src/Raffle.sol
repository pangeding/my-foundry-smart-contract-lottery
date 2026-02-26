// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// view & pure functions

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;


/**
 * @title A sample raffle contract
 * @author pangeding
 * @notice this contract is used for creating a sample raffle
 * @dev this implement ChainlinkVRFV2
 */
contract Raffle{
    error Raffle_NotEnoughEthSent();
    
    uint256 private immutable i_entranceFee = 0.01 ether;
    uint256 private immutable i_interval;
    address payable[] private s_players;
    uint256 private s_lastTimeStamp;
    

    /** event */
    event EnteredRaffle(address indexed player);

    constructor(uint256 entranceFee, uint256 interval){
        i_entranceFee = entranceFee;
        i_interval = interval;
        s_lastTimeStamp = block.timestamp;
    }

    function enterRaffle() public payable{
        if(msg.value < i_entranceFee){
            revert Raffle_NotEnoughEthSent();
        }   
        s_players.push(payable(msg.sender));
        // usage of event
        // 1. make migration easier
        // 2. make front end easier to "indexing"
        emit EnteredRaffle(msg.sender);
    }

    // 1. pick a random number
    // 2. use the random number to pick a player
    // 3. function should be automatically called 
    function pickWinner() public{
        // check to see if enough time has passed
        if(block.timestamp - s_lastTimeStamp < i_interval){
            revert();
        }

    }

    /** getter functions */
    function getEntranceFee() external view returns(uint256){
        return i_entranceFee;
    }
}