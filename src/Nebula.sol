// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {WorldIDVerifier} from "./WorldIDVerifier.sol";
import {NebulaRegistry} from "./NebulaRegistry.sol";
import {WorldIDProof} from "./Types.sol";
import {INebulaResolver} from "./INebulaResolver.sol";
import {IEAS, AttestationRequest, AttestationRequestData} from "eas-contracts/IEAS.sol";
import {NO_EXPIRATION_TIME, EMPTY_UID} from "eas-contracts/Common.sol";

contract Nebula {
    /// @dev Universal Nebula world id verifier
    NebulaRegistry registry;
    IEAS eas;

    /// @notice Errors to be thrown
    error ResolverIssueFail();
    error IdentityNotIssued();
    error IrrevocableIdentity();
    error IdentityAlreadyIssued();

    mapping(address => mapping(bytes8 => bool)) userIdentityMapping;
    mapping(address => mapping(bytes8 => bytes)) userIdentityDataMapping;
    mapping(address => bytes32) userAttestationMap;

    bytes32 easSchema;

    constructor(address _registry, address _eas, bytes32 _easSchema) {
        registry = NebulaRegistry(_registry);
        eas = IEAS(_eas);
        easSchema = _easSchema;
    }

    /// @notice Verifies a given proof and provides identity
    /// @param identity Identity identifier
    function claimIdentity(bytes8 identity, bytes calldata data) external {
        if (userIdentityMapping[msg.sender][identity])
            revert IdentityAlreadyIssued();

        INebulaResolver resolver = INebulaResolver(registry.resolve(identity));

        bool s = resolver.issue(msg.sender, data);

        if (!s) revert ResolverIssueFail();

        bytes32 uid = eas.attest(
            AttestationRequest({
                schema: easSchema,
                data: AttestationRequestData({
                    recipient: msg.sender,
                    expirationTime: NO_EXPIRATION_TIME,
                    revocable: true,
                    refUID: EMPTY_UID,
                    data: abi.encode(resolver, data),
                    value: 0
                })
            })
        );

        userIdentityMapping[msg.sender][identity] = true;
        userIdentityDataMapping[msg.sender][identity] = data;
        userAttestationMap[msg.sender] = uid;
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
