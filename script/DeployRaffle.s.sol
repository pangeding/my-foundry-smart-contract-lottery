// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {Raffle} from "../src/Raffle.sol";
// import {VRFCoordinatorV2Mock} from "@chainlink/contracts/src/v0.8/mocks/VRFCoordinatorV2Mock.sol";
// import {LinkToken} from "@chainlink/contracts/src/v0.8/mocks/LinkToken.sol";

contract DeployRaffle is Script {
    // uint96 public constant INITIAL_FUND_AMOUNT = 10 ether;
    // uint256 public constant GAS_LANE = 1000000000000000000; // 1 LINK

    /**
    function run() external returns (Raffle, HelperConfig) {
        HelperConfig helperConfig = new HelperConfig();
        HelperConfig.NetworkConfig memory config = helperConfig.activeNetworkConfig();

        if (config.subscriptionId == 0) {
            vm.startBroadcast();
            VRFCoordinatorV2Mock vrfCoordinatorMock = new VRFCoordinatorV2Mock(
                GAS_LANE,
                1000000000 // 0.000000001 LINK per gas
            );
            
            LinkToken linkToken = new LinkToken();
            vrfCoordinatorMock.setLINKAndFund(address(linkToken), INITIAL_FUND_AMOUNT);
            
            uint64 subscriptionId = vrfCoordinatorMock.createSubscription();
            vrfCoordinatorMock.addConsumer(subscriptionId, address(this));
            
            config.vrfCoordinator = address(vrfCoordinatorMock);
            config.subscriptionId = subscriptionId;
            vm.stopBroadcast();
        }

        vm.startBroadcast();
        Raffle raffle = new Raffle(
            config.entranceFee,
            config.interval,
            config.vrfCoordinator,
            config.gasLane,
            config.subscriptionId,
            config.callbackGasLimit
        );
        vm.stopBroadcast();

        return (raffle, helperConfig);
    }
    */

    function run() external returns (Raffle) {
        HelperConfig helperConfig = new HelperConfig();
        (
            uint256 entranceFee,
            uint256 interval,
            address vrfCoordinator,
            bytes32 gasLane,
            uint64 subscriptionId,
            uint32 callbackGasLimit
        ) = helperConfig.activeNetworkConfig();


        vm.startBroadcast();
        Raffle raffle = new Raffle(
            entranceFee,
            interval,
            vrfCoordinator,
            gasLane,
            subscriptionId,
            callbackGasLimit
        );
        vm.stopBroadcast(); 

        return raffle;
   }

}