# Nicholas West, 2024
# Cocotb test file for the divider

import time
import random

import cocotb
from cocotb.clock import Clock
import cocotb.triggers

testWidth = 32

@cocotb.test()
async def test_project(dut):
	dut._log.info("Start")

	# Set the clock period to 33 ns (~30 MHz)
	clock = Clock(dut.clk, 33, units="ns")
	cocotb.start_soon(clock.start())

	# Reset
	dut._log.info("Reset")
	dut.dividend.value = 0
	dut.divisor.value = 0
	dut.start.value = 0
	dut.rst_n.value = 0
	await cocotb.triggers.ClockCycles(dut.clk, 10)
	dut.rst_n.value = 1

	dut._log.info("Test project behavior")

	# Extremely simple test calculation for basic verification
	dut.dividend.value = 15
	dut.divisor.value = 4

	dut.start.value = 1
	await cocotb.triggers.ClockCycles(dut.clk, 1)
	dut.start.value = 0
	await cocotb.triggers.ClockCycles(dut.clk, 40)
	assert dut.remainder.value.integer == 15 % 4

	# Actual tests of divider
	for i in range(testWidth):
		dividend = random.randint(0, 2147483648 -1)
		divisor = random.randint(0, 2147483648 -1)
		dut.dividend.value = dividend
		dut.divisor.value = divisor

		dut.start.value = 1
		await cocotb.triggers.ClockCycles(dut.clk, 1)
		dut.start.value = 0
		await cocotb.triggers.RisingEdge(dut.data_ready)
		assert dut.remainder.value.integer == dividend % divisor

# Can we do another test? Who knows!

