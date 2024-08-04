// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.24;

interface INebulaResolver {
    function issue(
        address recipient,
        bytes calldata data
    ) external returns (bool);

    function verify(
        address recipient,
        bytes calldata data
    ) external view returns (bool);

    function revoke(
        address recipient,
        bytes calldata data
    ) external returns (bool);
}
