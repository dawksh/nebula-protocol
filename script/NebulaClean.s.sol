// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/NebulaRegistry.sol";
import {Nebula} from "../src/Nebula.sol";
import {EASNebulaResolver} from "../src/EASNebulaResolver.sol";
import {IEAS, Attestation} from "eas-contracts/IEAS.sol";

contract NebulaClean is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        IEAS eas = IEAS(0x4200000000000000000000000000000000000021);
        bytes32 easSchema = bytes32(0);

        EASNebulaResolver easResolver = new EASNebulaResolver(eas);

        NebulaRegistry registry = new NebulaRegistry();

        Nebula nebula = new Nebula(address(registry), address(eas), easSchema);

        vm.stopBroadcast();
    }
}
