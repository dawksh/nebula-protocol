// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Nebula} from "../src/Nebula.sol";

contract NebulaTest is Test {
    Nebula public nebula;

    function setUp() public {
        nebula = new Nebula();
    }

    function testNebula() public {}
}
