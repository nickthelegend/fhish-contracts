// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

type euint32 is uint256;
type ebool is uint256;

library FHE {
    function asEuint32(bytes memory ciphertext) internal pure returns (euint32) {
        require(ciphertext.length >= 32, "Invalid ciphertext len");
        uint256 result;
        assembly {
            result := mload(add(ciphertext, 32))
        }
        return euint32.wrap(result);
    }

    function add(euint32 a, euint32 b) internal pure returns (euint32) {
        return euint32.wrap(euint32.unwrap(a) + euint32.unwrap(b));
    }

    function sub(euint32 a, euint32 b) internal pure returns (euint32) {
        return euint32.wrap(euint32.unwrap(a) - euint32.unwrap(b));
    }

    function eq(euint32 a, euint32 b) internal pure returns (ebool) {
        return ebool.wrap(euint32.unwrap(a) == euint32.unwrap(b) ? 1 : 0);
    }

    function gte(euint32 a, euint32 b) internal pure returns (ebool) {
        return ebool.wrap(euint32.unwrap(a) >= euint32.unwrap(b) ? 1 : 0);
    }

    function decrypt(euint32 value) internal pure returns (uint256 requestId) {
        return euint32.unwrap(value);
    }
}
