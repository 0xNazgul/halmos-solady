// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract UnsafeDiv {
    function solmateUnsafeDiv(uint256 x, uint256 y) public pure returns (uint256 r) {
        /// @solidity memory-safe-assembly
        assembly {
            // Divide x by y. Note this will return
            // 0 instead of reverting if y is zero.
            r := div(x, y)
        }
    }    

    function soladyRawDiv(uint256 x, uint256 y) public pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            z := div(x, y)
        }
    }    
  
}