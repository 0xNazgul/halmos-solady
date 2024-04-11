// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/functions/MulDivUp.sol";

// Halmos isn't able to prove the correctness, because the math to get the correct value in pure Solidity is too complex.
// So we prove the correctness with a fuzz test and then prove the equivalence of the two full functions with Halmos.

// To run:
// - `forge test --mt test__MulDivUpCorrectness` (fuzz for correctness of both versions)
// - `halmos --function testCheck__MulDivUpEquivalence` (proves equivalence of two implementations)

contract MulDivUpTests is Test {
    MulDivUp c;

    function setUp() public {
        c = new MulDivUp();
    }

    // Fuzz test to check that both MulDivUp functions appear to be correct.
    function test__MulDivUpCorrectness(uint128 _x, uint128 _y, uint128 _z) public {
        uint x = uint(_x);
        uint y = uint(_y);
        uint z = uint(_z);

        //require(z != 0 && (y == 0 || x <= type(uint256).max / y));
        if (z != 0 && (y == 0 || x <= type(uint256).max / y)) {
            uint solution = x * y / z;
            if (solution * z < x * y) {
                solution += 1;
            }

            uint solmate = c.solmateMulDivUp(x, y, z);
            uint solady = c.soladyFullMulDivUp(x, y, z);

            assertEq(solution, solmate);
            assertEq(solution, solady);
        }
    }

    // Symbolic test to confirm that the two functions result in same output.
    function testCheck__MulDivUpEquivalence(uint128 _x, uint128 _y, uint128 _z) public {
        uint x = uint(_x);
        uint y = uint(_y);
        uint z = uint(_z);

        if (z != 0 && (y == 0 || x <= type(uint256).max / y)) {
            uint solmate = c.solmateMulDivUp(x, y, z);
            uint solady = c.soladyFullMulDivUp(x, y, z);

            assertEq(solmate, solady);
        }
    }
}
