// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/NebulaRegistry.sol";
import {WorldIDVerifier} from "../src/WorldIdVerifier.sol";

contract MyScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        NebulaRegistry registry = new NebulaRegistry();

        vm.stopBroadcast();
    }
}
