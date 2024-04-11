// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/functions/MulDivDown.sol";

// Halmos is able to handle this one exactly as-is.

// To run:
// - `halmos --function testCheck__MulDivDownCorrectnessAndEquivalence` (proves equivalence of two implementations)

contract MulDivDownTests is Test {
    MulDivDown c;

    function setUp() public {
        c = new MulDivDown();
    }

    // Symbolic test to check that both MulDivDown functions appear to be correct.
    function testCheck__MulDivDownCorrectnessAndEquivalence(uint128 _x, uint128 _y, uint128 _z) public {
        uint x = uint(_x);
        uint y = uint(_y);
        uint z = uint(_z);

        uint solution = x * y / z;
        uint solmate = c.solmateMulDivDown(x, y, z);
        uint solady = c.solmateFullMulDiv(x, y, z);

        assertEq(solution, solmate);
        assertEq(solution, solady);
    }    
}