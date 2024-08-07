// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Nebula} from "../src/Nebula.sol";
import {NebulaRegistry} from "../src/NebulaRegistry.sol";

contract NebulaTest is Test {
    Nebula public nebula;
    NebulaRegistry public registry;

    function setUp() public {
        registry = new NebulaRegistry();
        // update with correct verifier contract address
        nebula = new Nebula(
            0x5B38Da6a701c568545dCfcB03FcB875f56beddC4,
            address(registry),
            0x5B38Da6a701c568545dCfcB03FcB875f56beddC4,
            0x6f8e6a1394bdc398f8d93a99b0ecca326d04470a4f0ee5c379bb85a458a322e4
        );
    }

    function testNebula() public {}
}
