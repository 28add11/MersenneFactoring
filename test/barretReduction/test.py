# Nicholas West, 2025
# Cocotb test file for the Barret Reduction implementation

from math import ceil, log2, sqrt
import random

import cocotb
from cocotb.clock import Clock
import cocotb.triggers

testWidth = 1000
		
@cocotb.test()
async def test_mult(dut):
	dut._log.info("Start")

	# Set the clock period to 33 ns (~30 MHz)
	clock = Clock(dut.clk, 33, units="ns")
	cocotb.start_soon(clock.start())

	# Reset
	dut._log.info("Reset")
	dut.numerator.value = 0
	dut.denominator.value = 0
	dut.R.value = 0
	dut.constant.value = 0
	dut.rst_n.value = 0
	await cocotb.triggers.ClockCycles(dut.clk, 10)
	dut.rst_n.value = 1

	dut._log.info("Test project behavior")

	# Extremely simple test calculation for basic verification
	dut.numerator.value = 63
	dut.denominator.value = 25
	r = ceil(log2(25)) << 1
	const = (1 << r) // 25
	dut.R.value = r
	dut.constant.value = const
	dut.start.value = 1
	await cocotb.triggers.ClockCycles(dut.clk, 1)
	dut.start.value = 0
	await cocotb.triggers.ClockCycles(dut.clk, 2)
	assert dut.remainder.value.integer == 63 % 25
	
	for i in range(testWidth):

		n = random.randint(2, (2**24) - 1)
		m = random.randint(ceil(sqrt(n)), n) # Actually test the division
		dut.numerator.value = n
		dut.denominator.value = m
		print(f"Testing {n} mod {m}")
		r = ceil(log2(m)) << 1
		const = (1 << r) // m
		dut.R.value = r
		dut.constant.value = const
		dut.start.value = 1
		await cocotb.triggers.ClockCycles(dut.clk, 1)
		dut.start.value = 0
		await cocotb.triggers.ClockCycles(dut.clk, 2)
		assert dut.remainder.value.integer == n % m
		