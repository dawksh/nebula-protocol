// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {WorldIDVerifier} from "./WorldIDVerifier.sol";

contract Nebula {
    /// @dev Universal Nebula world id verifier
    WorldIDVerifier verifier;

    struct WorldIDProof {
        address signal;
        uint256 root;
        uint256 nullifierHash;
        uint256[8] proof;
    }

    /// @param _verifier Universal verifier for worldid
    constructor(address _verifier) {
        verifier = WorldIDVerifier(_verifier);
    }

    /// @notice Verifies a given proof
    /// @param proof WorldID Proof
    /// @param identity WorldID Proof
    function verifyIdentity(
        WorldIDProof calldata proof,
        bytes8 identity
    ) external {
        verifier.verifyAndExecute(
            proof.signal,
            proof.root,
            proof.nullifierHash,
            proof.proof
        );

        // Resolve Identity, Verify and Issue
    }
}
