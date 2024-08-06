// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.24;

import {Nebula} from "./Nebula.sol";
import {SchemaResolver} from "eas-contracts/resolver/SchemaResolver.sol";
import {IEAS, Attestation} from "eas-contracts/IEAS.sol";

contract EASNebulaResolver is SchemaResolver {
    Nebula nebula;

    constructor(Nebula _nebula, IEAS eas) SchemaResolver(eas) {
        nebula = _nebula;
    }

    function onAttest(
        Attestation calldata attestation,
        uint256 /*value*/
    ) internal view override returns (bool) {
        return attestation.attester == address(nebula);
    }

    function onRevoke(
        Attestation calldata attestation,
        uint256 /*value*/
    ) internal view override returns (bool) {
        return attestation.attester == address(nebula);
    }
}
