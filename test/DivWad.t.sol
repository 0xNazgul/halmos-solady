// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/functions/DivWad.sol";

// Halmos is able to handle this one exactly as-is.

// To run:
// - `halmos --function testCheck__DivWadCorrectnessAndEquivalence` (proves correctness of both implementations and equivalence)

contract DivWadTests is Test {
    DivWad c;

    function setUp() public {
        c = new DivWad();
    }

    // Symbolic test to confirm that the two functions result in same output.
    function testCheck__DivWadCorrectnessAndEquivalence(uint128 _x, uint128 _y) public {
        uint x = uint(_x);
        uint y = uint(_y);

        uint solution = (x * c.WAD()) / y;
        uint solmate = c.solmateDivWadDown(x, y);
        uint solady = c.soladyDivWad(x, y);

        assertEq(solution, solmate);
        assertEq(solution, solady);
    }
}