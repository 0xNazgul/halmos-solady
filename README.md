# Using Halmos to Formally Verify Solady's FixedPointMathLib

**NOTE**: Was learning the basics of how to use Halmos and found this repo from [zobront](https://github.com/zobront). The repo, as of writing, is a year old. So I just took it as an exercise opportunity to finish off some of the function tests. Uploading it in case someone finds some use of it.

Halmos is a symbolic bounded model checker. It takes in EVM bytecode, converts it to a series of equations, and uses Z3 Theorem Prover to verify the assertion or find counterexamples.

Z3 struggles with certain types of equations, so we can't just formally verify everything. Depending on the situation, either:
- We can formally verify the full result
- We can formally verify it's equivalence with a reference implementation (we use Solmate)
- We can formally verify pieces of it vs a reference implementation
- We aren't able to do anything useful :(

This repo is a work in progress, focused on verifying the functions with to the highest degree possible.

## Repo Organization

Because of the limitations of deployed contract size in Halmos tests, all functions are broken apart into separate contracts in `src/`.

Each function has a separate test in `test/`. Some tests are written for Foundry fuzzing, while others are written for Halmos. Instructions are provided at the top of each test file explaining how best to run each test.

## FixedPointMathLib Functions

- [x] sqrt
- [x] mulWad
- [x] mulWadUp
- [x] divWad
- [x] divWadUp
- [x] mulDivDown
- [ ] mulDivUp (TODO Equivalence: gets hung up not sure why yet)
- [ ] rpow
- [x] unsafeMod
- [x] unsafeDiv
- [x] unsafeDivUp

## Detailed Breakdown
### ✅ sqrt()

To run:
- `forge test --match test__SqrtCorrectness` (fuzz for correctness of both versions)
- `halmos --function test__SqrtEquivalence` (symbolic test of equivalence)

Explanation: All differences between the two implementations exist in the first half of the function, so we abstract out the final (identical) piece, to leave just the differences. We can then test `solmateSqrt` and `soladySqrt` with a fuzz test to ensure the changes didn't break anything. Once this is provide, we can remove the call to the identical internal function, leaving `solmateSqrtStripped` and `soladySqrtStripped`, which we can test for equivalence with Halmos.

### ✅ mulWad()

To run:
- `halmos --function test__MulWadCorrectnessAndEquivalence` (proves correctness of both implementations and equivalence)

Explanation: This one is relatively simple with minimal division, so Halmos can handle the functions as-is. We simply compare them both to a non-assembly non-optimized version, and prove equivalence.

### ✅ mulWadUp()

To run:
- `forge test --match test__MulWadUpCorrectness` (fuzz for correctness of both versions)
- `halmos --function test__MulWadUpEquivalence` (proves equivalence of two implementations)

Explanation: Halmos isn't able to prove the correctness, because the math to get the correct value in pure Solidity is too complex. So we prove the correctness with a fuzz test and then prove the equivalence of the two full functions with Halmos.
