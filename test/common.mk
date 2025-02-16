
# defaults
SIM ?= icarus
WAVES=1
TOPLEVEL_LANG ?= verilog

# RTL simulation:
SIM_BUILD = sim_build/rtl

# Include the testbench sources:
VERILOG_SOURCES += $(PWD)/tb.v 
TOPLEVEL = tb

# MODULE is the basename of the Python test file
MODULE = test
