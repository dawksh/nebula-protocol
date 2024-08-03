// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Nebula} from "../src/Nebula.sol";

contract NebulaTest is Test {
    Nebula public nebula;

    function setUp() public {
        // update with correct verifier contract address
        nebula = new Nebula(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4);
    }

    function testNebula() public {}
}
