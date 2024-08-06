// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {WorldIDVerifier} from "./WorldIDVerifier.sol";
import {NebulaRegistry} from "./NebulaRegistry.sol";
import {WorldIDProof} from "./Types.sol";
import {INebulaResolver} from "./INebulaResolver.sol";
import {IEAS} from "eas-contracts/IEAS.sol";

contract Nebula {
    /// @dev Universal Nebula world id verifier
    WorldIDVerifier verifier;
    NebulaRegistry registry;

    /// @notice Errors to be thrown
    error ResolverIssueFail();
    error IdentityNotIssued();
    error IrrevocableIdentity();
    error IdentityAlreadyIssued();

    mapping(address => mapping(bytes8 => bool)) userIdentityMapping;
    mapping(address => mapping(bytes8 => bytes)) userIdentityDataMapping;

    /// @param _verifier Universal verifier for worldid
    constructor(address _verifier, address _registry) {
        verifier = WorldIDVerifier(_verifier);
        registry = NebulaRegistry(_registry);
    }

    /// @notice Verifies a given proof and provides identity
    /// @param proof WorldID Proof
    /// @param identity WorldID Proof
    function claimIdentity(
        WorldIDProof calldata proof,
        bytes8 identity,
        bytes calldata data
    ) external {
        if (userIdentityMapping[msg.sender][identity])
            revert IdentityAlreadyIssued();

        INebulaResolver resolver = INebulaResolver(registry.resolve(identity));

        verifier.verifyAndExecute(
            address(resolver),
            proof.root,
            proof.nullifierHash,
            proof.proof
        );

        bool s = resolver.issue(msg.sender, data);

        if (!s) revert ResolverIssueFail();

        //TODO: Attest for identity

        userIdentityMapping[msg.sender][identity] = true;
        userIdentityDataMapping[msg.sender][identity] = data;
    }

    /// @notice Verifies previously issued identity to a user
    /// @param identity the identity type
    /// @param user the user whose identity is being verified
    /// @return Validity of the identity
    function verifyIdentity(
        bytes8 identity,
        address user
    ) external view returns (bool) {
        if (!userIdentityMapping[user][identity]) revert IdentityNotIssued();

        INebulaResolver resolver = INebulaResolver(registry.resolve(identity));

        return resolver.verify(user, userIdentityDataMapping[user][identity]);
    }

    function revokeIdentity(bytes8 identity, address user) external {
        if (!userIdentityMapping[user][identity]) revert IdentityNotIssued();

        INebulaResolver resolver = INebulaResolver(registry.resolve(identity));

        bool s = resolver.revoke(user, userIdentityDataMapping[user][identity]);

        if (!s) revert IrrevocableIdentity();

        delete userIdentityDataMapping[user][identity];
        userIdentityMapping[user][identity] = false;
    }
}
