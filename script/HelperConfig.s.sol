// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {VRFCoordinatorV2Mock} from "@chainlink/contracts/src/v0.8/vrf/mocks/VRFCoordinatorV2Mock.sol";

contract HelperConfig is Script {
    NetworkConfig public activeNetworkConfig;

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else {
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }

    struct NetworkConfig {
        uint256 entranceFee;
        uint256 interval;
        address vrfCoordinator;
        bytes32 gasLane;
        uint64 subscriptionId;
        uint32 callbackGasLimit;
    }

    function getSepoliaEthConfig() public view returns (NetworkConfig memory) {
        NetworkConfig memory sepoliaNetworkConfig = NetworkConfig({
            entranceFee: 0.01 ether,
            interval: 30,
            vrfCoordinator: 0x8103B0A8A00be2DDC778e6e7eaa21791Cd364625,
            gasLane: 0x474e34a077df58807dbe9c96d3c009b23b3c6d0cce433e59bbf5b34f823bc56c,
            subscriptionId: 0, // We will create and update this in the deploy script
            callbackGasLimit: 500000
        });
        return sepoliaNetworkConfig;
    }

    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        if (activeNetworkConfig.vrfCoordinator != address(0)) {
            return activeNetworkConfig;
        }

        uint96 _baseFee = 0.25 ether;
        uint96 _gasPriceLink = 1e9;

        vm.startBroadcast();
        VRFCoordinatorV2Mock vrfCoordinatorV2Mock = new VRFCoordinatorV2Mock(
            _baseFee,
            _gasPriceLink
        );
        vm.stopBroadcast();
    }

    /**
    uint256 public constant DEFAULT_ANVIL_PRIVATE_KEY = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;

    event HelperConfig__CreatedSubscription(uint64 subscriptionId);

    



    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        if (activeNetworkConfig.vrfCoordinator != address(0)) {
            return activeNetworkConfig;
        }
        uint64 subId = 0;
        address vrfCoordinator = address(0);

        if (subId == 0 || vrfCoordinator == address(0)) {
            console.log("Creating new subscription...");
            string[] memory broadcastCommand = new string[](7);
            broadcastCommand[0] = "cast";
            broadcastCommand[1] = "send";
            broadcastCommand[2] = "0x8103B0A8A00be2DDC778e6e7eaa21791Cd364625"; // VRF Coordinator address on Anvil
            broadcastCommand[3] = "createSubscription()";
            broadcastCommand[4] = "--rpc-url";
            broadcastCommand[5] = "http://127.0.0.1:8545";
            broadcastCommand[6] = "--private-key";
            broadcastCommand[7] = vm.toString(DEFAULT_ANVIL_PRIVATE_KEY);

            bytes memory returnedData = vm.ffi(broadcastCommand);
            (subId) = abi.decode(returnedData, (uint64));

            emit HelperConfig__CreatedSubscription(subId);
        }

        NetworkConfig memory anvilNetworkConfig = NetworkConfig({
            entranceFee: 0.01 ether,
            interval: 30,
            vrfCoordinator: vrfCoordinator,
            gasLane: 0x474e34a077df58807dbe9c96d3c009b23b3c6d0cce433e59bbf5b34f823bc56c,
            subscriptionId: subId,
            callbackGasLimit: 500000
        });
        return anvilNetworkConfig;
    }*/

}