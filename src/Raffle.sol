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

import {VRFCoordinatorV2Interface} from "@chainlink/contracts/src/v0.8/vrf/interfaces/VRFCoordinatorV2Interface.sol";
import {VRFConsumerBaseV2} from "@chainlink/contracts/src/v0.8/vrf/VRFConsumerBaseV2.sol";

/**
 * @title A sample raffle contract
 * @author pangeding
 * @notice this contract is used for creating a sample raffle
 * @dev this implement ChainlinkVRFV2
 */
contract Raffle is VRFConsumerBaseV2{
    error Raffle_NotEnoughEthSent();
    error Raffle_TransferFailed();
    error Raffle_RaffleNotOpen();

    uint16 private constant REQUEST_CONFIRMATIONS = 3;
    uint32 private constant NUM_WORDS = 1;
    
    uint256 private immutable i_entranceFee = 0.01 ether;
    uint256 private immutable i_interval;
    VRFCoordinatorV2Interface private immutable i_vrfCoordinator;
    bytes32 private immutable i_gasLane;
    uint64 private immutable i_subscriptionId;
    uint32 private immutable i_callbackGasLimit;

    address payable[] private s_players;
    uint256 private s_lastTimeStamp;
    address private s_recentWinner;
    RaffleState private s_raffleState;
    
    /** enum */
    enum RaffleState{
        OPEN,
        CALCULATING
    }

    /** event */
    event EnteredRaffle(address indexed player);
    event PickedWinner(address indexed winner);

    constructor(
        uint256 entranceFee, 
        uint256 interval, 
        address vrfCoordinatorV2,
        bytes32 gasLane,
        uint64 subscriptionId,
        uint32 callbackGasLimit
    )VRFConsumerBaseV2(vrfCoordinatorV2){
        i_entranceFee = entranceFee;
        i_interval = interval;
        s_lastTimeStamp = block.timestamp;
        s_raffleState = RaffleState.OPEN;
        i_vrfCoordinator = VRFCoordinatorV2Interface(vrfCoordinatorV2);
        i_gasLane = gasLane;
        i_subscriptionId = subscriptionId;
        i_callbackGasLimit = callbackGasLimit;
    }

    function enterRaffle() public payable{
        if(msg.value < i_entranceFee){
            revert Raffle_NotEnoughEthSent();
        }   
        if(s_raffleState != RaffleState.OPEN){
            revert Raffle_RaffleNotOpen();
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
        s_raffleState = RaffleState.CALCULATING;
        // 1. request the random number generator (RNG)
        // 2. get the random number back
        uint256 s_requestId = i_vrfCoordinator.requestRandomWords(
        i_gasLane,
        i_subscriptionId,
        REQUEST_CONFIRMATIONS,
        i_callbackGasLimit,
        NUM_WORDS
    );

    }

    function fulfillRandomWords(uint256, uint256[] memory randomWords) internal override{
        // 1. get the player index
        // 2. get the player
        // 3. send the player the amount
        // 4. reset the players
        uint256 indexOfWinner = randomWords[0] % s_players.length;
        address payable winner = s_players[indexOfWinner];
        s_recentWinner = winner;

        s_raffleState = RaffleState.OPEN;
        s_players = new address payable[](0);
        s_lastTimeStamp = block.timestamp;

        // transfer is deprecated, use call
        // winner.transfer(address(this).balance);
        (bool success, ) = winner.call{value: address(this).balance}("");
        if(!success){
            revert();
        }
        emit PickedWinner(winner);
    }


    /** getter functions */
    function getEntranceFee() external view returns(uint256){
        return i_entranceFee;
    }
}