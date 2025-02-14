# Nicholas West, 2025
# Cocotb test file for the multiplier of the mersenne factoring HDL project

import time
import random

import cocotb
import cocotb.triggers

testWidth = 500
		
@cocotb.test()
async def test_mult(dut):
	dut._log.info("Start")

	# Purely combinational, no clock. We just add this since it makes it easy for me to compare
	clock = Clock(dut.clk, 33, units="ns")
	cocotb.start_soon(clock.start())

	# Reset
	dut._log.info("Reset")
	dut.a.value = 0
	dut.b.value = 0
	dut.rst_n.value = 0
	await cocotb.triggers.ClockCycles(dut.clk, 10)
	dut.rst_n.value = 1

	dut._log.info("Test project behavior")

	# Extremely simple test calculation for basic verification
	dut.a.value = 63
	dut.b.value = 25
	await cocotb.triggers.ClockCycles(dut.clk, 1)
	assert dut.y.value.integer == 63 * 25

	for i in range(testWidth):
		a = random.randint(0, (2**32) - 1)
		b = random.randint(0, (2**32) - 1)
		dut.a.value = a
		dut.b.value = b

		await cocotb.triggers.ClockCycles(dut.clk, 1)
		assert dut.y.value.integer == a * b