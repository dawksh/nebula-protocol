// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {WorldIDVerifier} from "./WorldIDVerifier.sol";
import {NebulaRegistry} from "./NebulaRegistry.sol";
import {WorldIDProof} from "./Types.sol";
import {INebulaResolver} from "./INebulaResolver.sol";

contract Nebula {
    /// @dev Universal Nebula world id verifier
    WorldIDVerifier verifier;
    NebulaRegistry registry;

    /// @notice Error to be thrown when issuance is failed
    error ResolverIssueFail();

    /// @param _verifier Universal verifier for worldid
    constructor(address _verifier, address _registry) {
        verifier = WorldIDVerifier(_verifier);
        registry = NebulaRegistry(_registry);
    }

    /// @notice Verifies a given proof
    /// @param proof WorldID Proof
    /// @param identity WorldID Proof
    function claimIdentity(
        WorldIDProof calldata proof,
        bytes8 identity,
        bytes calldata data
    ) external {
        INebulaResolver resolver = INebulaResolver(registry.resolve(identity));
        verifier.verifyAndExecute(
            address(resolver),
            proof.root,
            proof.nullifierHash,
            proof.proof
        );

        bool s = resolver.issue(msg.sender, data);

        if (!s) revert ResolverIssueFail();
    }
}
