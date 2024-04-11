// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract UnsafeDivUp {
   function soladyDivUp(uint256 x, uint256 d) public pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            if iszero(d) {
                // Store the function selector of `DivFailed()`.
                mstore(0x00, 0x65244e4e)
                // Revert with (offset, size).
                revert(0x1c, 0x04)
            }
            z := add(iszero(iszero(mod(x, d))), div(x, d))
        }
    }

    function solmateUnsafeDivUp(uint256 x, uint256 y) public pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            // Add 1 to x * y if x % y > 0. Note this will
            // return 0 instead of reverting if y is zero.
            z := add(gt(mod(x, y), 0), div(x, y))
        }
    }    
}