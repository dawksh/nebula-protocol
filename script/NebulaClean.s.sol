// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/NebulaRegistry.sol";
import {Nebula} from "../src/Nebula.sol";

contract NebulaClean is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        address eas = address(0);
        bytes32 easSchema = bytes32(0);

        NebulaRegistry registry = new NebulaRegistry();

        Nebula nebula = new Nebula(address(registry), eas, easSchema);

        vm.stopBroadcast();
    }
}
