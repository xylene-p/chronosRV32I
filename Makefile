# root_dir = $(shell pwd)
# IV_FLAGS = 

all: 

stageIFID:
	iverilog -Iinc -o output/stage_IFID_tb.out src/register_pc.v src/inst_mem.v src/register_IFID.v test/stage_IFID_tb.v
	vvp output/stage_IFID_tb.out