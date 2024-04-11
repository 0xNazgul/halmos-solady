// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/functions/DivWadUp.sol";

// Halmos isn't able to prove the correctness, because the math to get the correct value in pure Solidity is too complex.
// So we prove the correctness with a fuzz test and then prove the equivalence of the two full functions with Halmos.

// To run:
// - `forge test --mt test__MulWadUpCorrectness` (fuzz for correctness of both versions)
// - `halmos --function testCheck__DivWadUpEquivalence` (proves correctness of both implementations and equivalence)

contract DivWadUpTests is Test {
    DivWadUp c;

    function setUp() public {
        c = new DivWadUp();
    }

    // Fuzz test to check that both mulWadUp functions appear to be correct.
    function test__DivWadUpCorrectness(uint128 _x, uint128 _y) public {
        uint x = uint(_x);
        uint y = uint(_y);

        uint solution = (x * c.WAD()) / y;
        if (solution / c.WAD() < x / y) {
            solution += 1;
        }

        uint solmate = c.solmateDivWadUp(x, y);
        uint solady = c.soladyDivWadUp(x, y);

        assertEq(solution, solmate);
        assertEq(solution, solady);
    }    

    // Symbolic test to confirm that the two functions result in same output.
    function testCheck__DivWadUpEquivalence(uint128 _x, uint128 _y) public {
        uint x = uint(_x);
        uint y = uint(_y);

        uint solmate = c.solmateDivWadUp(x, y);
        uint solady = c.soladyDivWadUp(x, y);

        assertEq(solmate, solady);
    }
}