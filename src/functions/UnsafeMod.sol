// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract UnsafeMod {

    function solmateUnsafeMod(uint256 x, uint256 y) public pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            // Mod x by y. Note this will return
            // 0 instead of reverting if y is zero.
            z := mod(x, y)
        }
    }

    function soladyRawMod(uint256 x, uint256 y) public pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            z := mod(x, y)
        }
    }    
}