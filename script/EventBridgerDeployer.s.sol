// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { Script } from "forge-std/Script.sol";
import { console } from "forge-std/console.sol";
import { EventBridger } from "../src/EventBridger.sol";

contract EventBridgerDeployer is Script {
    function setUp() public {}

    modifier asDeployer() {
        uint256 deployerPrivateKey = vm.envUint("DEPLOYER_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        _;
        vm.stopBroadcast();
    }

    function run() public asDeployer {

        console.log("Deploying a new EventBridger");
        EventBridger eventBridger = new EventBridger();
        console.log("eventBridger deployed at address: ", address(eventBridger));
        console.log("eventBridger owner: ", address(eventBridger.owner()));
    }
}