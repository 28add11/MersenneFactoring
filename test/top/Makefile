# Makefile

include ../common.mk

# defaults
SRC_DIR = $(PWD)/../../src
PROJECT_SOURCES = divider.v square.v mersenneFactoring.v

# RTL simulation:
VERILOG_SOURCES += $(addprefix $(SRC_DIR)/,$(PROJECT_SOURCES))
COMPILE_ARGS 		+= -I$(SRC_DIR)

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim
