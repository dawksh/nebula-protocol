// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.24;

contract NebulaRegistry {
    mapping(bytes8 => address) registeryMapping;

    event IdentityRegistered(address, bytes8 indexed);

    function register(address identity) external returns (bytes8) {
        bytes8 identifier = bytes8(
            keccak256(abi.encodePacked(identity, msg.sender))
        );
        registeryMapping[identifier] = identity;
        emit IdentityRegistered(identity, identifier);
        return identifier;
    }

    function resolve(bytes8 identity) external view returns (address) {
        return registeryMapping[identity];
    }
}
