// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/functions/UnsafeMod.sol";

// Halmos isn't able to prove the correctness, because the math to get the correct value in pure Solidity is too complex.
// So we prove the correctness with a fuzz test and then prove the equivalence of the two full functions with Halmos.

// To run:
// - `forge test --mt test__UnsafeModCorrectness` (fuzz for correctness of both versions)
// - `halmos --function testCheck__UnsafeModEquivalence` (proves equivalence of two implementations)

contract UnsafeModTests is Test {
    UnsafeMod c;

    function setUp() public {
        c = new UnsafeMod();
    }

    // Fuzz test to check that both UnsafeMod functions appear to be correct.
    function test__UnsafeModCorrectness(uint128 _x, uint128 _y) public {
        uint x = uint(_x);
        uint y = uint(_y);

        if (y != 0) {
            uint solution = x % y;
            uint solmate = c.solmateUnsafeMod(x, y);
            uint solady = c.soladyRawMod(x, y);

            assertEq(solution, solmate);
            assertEq(solution, solady);            
        } else {
            uint solmate = c.solmateUnsafeMod(x, y);
            uint solady = c.soladyRawMod(x, y);

            assertEq(0, solmate);
            assertEq(0, solady);   
        }
    }

    // Symbolic test to confirm that the two functions result in same output.
    function testCheck__UnsafeModEquivalence(uint128 _x, uint128 _y) public {
        uint x = uint(_x);
        uint y = uint(_y);

        uint solmate = c.solmateUnsafeMod(x, y);
        uint solady = c.soladyRawMod(x, y);

        assertEq(solmate, solady);
    }
}
