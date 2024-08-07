// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.24;

import {INebulaResolver} from "../INebulaResolver.sol";

contract MinimalResolver is INebulaResolver {
    function issue(
        address /*recipient*/,
        bytes calldata /*data*/
    ) external pure returns (bool) {
        return true;
    }

    function verify(
        address /*recipient*/,
        bytes calldata /*data*/
    ) external pure returns (bool) {
        return true;
    }

    function revoke(
        address /*recipient*/,
        bytes calldata /*data*/
    ) external pure returns (bool) {
        return false;
    }
}
