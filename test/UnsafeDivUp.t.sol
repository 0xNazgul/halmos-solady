// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/functions/UnsafeDivUp.sol";

// Halmos isn't able to prove the correctness, because the math to get the correct value in pure Solidity is too complex.
// So we prove the correctness with a fuzz test and then prove the equivalence of the two full functions with Halmos.

// To run:
// - `forge test --mt test__UnsafeDivUpCorrectness` (fuzz for correctness of both versions)
// - `halmos --function testCheck__UnsafeDivUpEquivalence` (proves equivalence of two implementations)

contract UnsafeDivUpTests is Test {
    UnsafeDivUp c;

    function setUp() public {
        c = new UnsafeDivUp();
    }

    // Fuzz test to check that both UnsafeDivUp functions appear to be correct.
    function test__UnsafeDivUpCorrectness(uint128 _x, uint128 _y) public {
        uint x = uint(_x);
        uint y = uint(_y);

        if (y != 0) {
            uint solution = x / y;
            if (x % y > 0) {
                solution += 1;
            }            
            uint solmate = c.solmateUnsafeDivUp(x, y);
            uint solady = c.soladyDivUp(x, y);

            assertEq(solution, solmate);
            assertEq(solution, solady);
        }
    }

    // Symbolic test to confirm that the two functions result in same output.
    function testCheck__UnsafeDivUpEquivalence(uint128 _x, uint128 _y) public {
        uint x = uint(_x);
        uint y = uint(_y);

        if (y != 0) {
            uint solution = x / y;
            if (x % y > 0) {
                solution += 1;
            }     
            uint solmate = c.solmateUnsafeDivUp(x, y);
            uint solady = c.soladyDivUp(x, y);

            assertEq(solmate, solady);
        }
    }
}
