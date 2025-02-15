import time
import random

import cocotb
from cocotb.clock import Clock
import cocotb.triggers

testWidth = 500 # How many tests to run through (TODO: use make to set this value)

@cocotb.test()
async def test(dut):
	dut._log.info("Start")

	# Set the clock period to 33 ns (~30 MHz)
	clock = Clock(dut.clk, 33, units="ns")
	cocotb.start_soon(clock.start())

	# Reset
	dut._log.info("Reset")
	dut.x.value = 0
	dut.rst_n.value = 0
	await cocotb.triggers.ClockCycles(dut.clk, 10)
	dut.rst_n.value = 1

	dut._log.info("Test project behavior")

	# Simple test calculation for basic verification
	dut.x.value = 63
	await cocotb.triggers.ClockCycles(dut.clk, 1)
	assert dut.y.value.integer == 63**2

	for i in range(testWidth): # Actually doing the testing
		x = random.randint(0, (2**32) - 1)
		dut.x.value = x

		await cocotb.triggers.ClockCycles(dut.clk, 1)
		assert dut.y.value.integer == x**2
