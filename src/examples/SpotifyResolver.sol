// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.24;

import {INebulaResolver} from "../INebulaResolver.sol";

contract SpotifyResolver is INebulaResolver {
    address owner;

    constructor() {
        owner = msg.sender;
    }

    // keccak256 hash of zero bytes
    bytes32 ZERO_BYTES_KECCAK =
        0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;

    mapping(address => bytes) userVerificationData;

    // data will contain signature (r, s, v) and hashed data
    function issue(
        address recipient,
        bytes calldata data
    ) external returns (bool) {
        bytes32 hash;
        bytes32 r;
        bytes32 s;
        uint8 v;
        (hash, r, s, v) = abi.decode(data, (bytes32, bytes32, bytes32, uint8));
        address signer = ecrecover(hash, v, r, s);
        if (signer != owner) return false;
        userVerificationData[recipient] = data;
        return true;
    }

    function verify(
        address recipient,
        bytes calldata /*data*/
    ) external view returns (bool) {
        if (keccak256(userVerificationData[recipient]) == ZERO_BYTES_KECCAK)
            return false;
        return true;
    }

    function revoke(
        address /*recipient*/,
        bytes calldata /*data*/
    ) external pure returns (bool) {
        return false;
    }
}
