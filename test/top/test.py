# Nicholas West, 2025
# Cocotb test file for the mersenne factoring HDL project

import time
import random

import cocotb
from cocotb.clock import Clock
import cocotb.triggers

testWidth = 500
		
@cocotb.test()
async def test(dut):
	dut._log.info("Start")

	# Set the clock period to 20 ns (50 MHz)
	clock = Clock(dut.clk, 20, units="ns")
	cocotb.start_soon(clock.start())

	# Reset
	dut._log.info("Reset")
	dut.rst_n.value = 0
	await cocotb.triggers.ClockCycles(dut.clk, 10)
	dut.rst_n.value = 1

	dut._log.info("Test project behavior")

	# Test calculation based on one on mersenne.org website
	dut.divisor.value = 47
	dut.exponent.value = 23
	dut.start.value = 1
	await cocotb.triggers.ClockCycles(dut.clk, 1)
	dut.start.value = 0
	await cocotb.triggers.RisingEdge(dut.data_ready)
	assert dut.divisibility.value.integer == 1 # i.e. not prime, since 47 is a factor of 2^23 - 1

	# Bulk tests with known primes and known non-primes
	mersennePrimeExponents = [7, 13, 17, 19, 31]
	nonPrimeExponents = [11, 27, 29, 30]
	testPrimes = [mersennePrimeExponents, nonPrimeExponents]
	divisorPrimes = [2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71,73,79,83,89,97,101,103,107,109,113,127,
			   131,137,139,149,151,157,163,167,173,179,181,191,193,197,199,211,223,227,229,233,239,241,251,257,263,
			   269,271,277,281,283,293,307,311,313,317,331,337,347,349,353,359,367,373,379,383,389,397,401,409,419,421,
			   431,433,439,443,449,457,461,463,467,479,487,491,499,503,509,521,523,541,547]
	for i in testPrimes:
		dut._log.info("Testing " + str(i))
		for j in i:
			divisiblePrimes = 0
			for k in [x for x in divisorPrimes if x < (1 << j) - 1]:
				dut.divisor.value = k
				dut.exponent.value = j
				dut.start.value = 1
				await cocotb.triggers.ClockCycles(dut.clk, 1)
				dut.start.value = 0
				await cocotb.triggers.RisingEdge(dut.data_ready)
				divisiblePrimes = divisiblePrimes + dut.divisibility.value.integer
			dut._log.info(f"Number {j} is divisible by {divisiblePrimes} primes")
			if i == mersennePrimeExponents:
				assert divisiblePrimes == 0
			else: 
				assert divisiblePrimes > 0
