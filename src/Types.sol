// SPDX-License-Identifier: Unlicencsed

pragma solidity ^0.8.24;

struct WorldIDProof {
    address signal;
    uint256 root;
    uint256 nullifierHash;
    bytes proof;
}
