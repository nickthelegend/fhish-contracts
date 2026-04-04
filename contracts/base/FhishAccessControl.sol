// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract FhishAccessControl {
    mapping(address => mapping(uint256 => bool)) private permissions;

    function grantPermission(address user, uint256 ciphertextHandle) external {
        permissions[user][ciphertextHandle] = true;
    }

    function revokePermission(address user, uint256 ciphertextHandle) external {
        permissions[user][ciphertextHandle] = false;
    }

    function hasPermission(address user, uint256 ciphertextHandle) external view returns (bool) {
        return permissions[user][ciphertextHandle];
    }
}
