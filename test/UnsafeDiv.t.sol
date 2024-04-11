// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/functions/UnsafeDiv.sol";

// Halmos isn't able to prove the correctness, because the math to get the correct value in pure Solidity is too complex.
// So we prove the correctness with a fuzz test and then prove the equivalence of the two full functions with Halmos.

// To run:
// - `forge test --mt test__UnsafeDivCorrectness` (fuzz for correctness of both versions)
// - `halmos --function testCheck__UnsafeDivEquivalence` (proves equivalence of two implementations)

contract UnsafeDivTests is Test {
    UnsafeDiv c;

    function setUp() public {
        c = new UnsafeDiv();
    }

    // Fuzz test to check that both UnsafeDiv functions appear to be correct.
    function test__UnsafeDivCorrectness(uint128 _x, uint128 _y) public {
        uint x = uint(_x);
        uint y = uint(_y);

        if (y != 0) {
            uint solution = x / y;
            uint solmate = c.solmateUnsafeDiv(x, y);
            uint solady = c.soladyRawDiv(x, y);

            assertEq(solution, solmate);
            assertEq(solution, solady);            
        } else {
            uint solmate = c.solmateUnsafeDiv(x, y);
            uint solady = c.soladyRawDiv(x, y);

            assertEq(0, solmate);
            assertEq(0, solady);   
        }
    }

    // Symbolic test to confirm that the two functions result in same output.
    function testCheck__UnsafeDivEquivalence(uint128 _x, uint128 _y) public {
        uint x = uint(_x);
        uint y = uint(_y);

        uint solmate = c.solmateUnsafeDiv(x, y);
        uint solady = c.soladyRawDiv(x, y);

        assertEq(solmate, solady);
    }
}
