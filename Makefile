# root_dir = $(shell pwd)
# IV_FLAGS = 

VC=iverilog
FLAGS=-I

IFIDSOURCES= src/register_pc.v \
src/inst_mem.v \
src/register_IFID.v \
src/add_const.v \
src/mux_4_1.v


IDEXSOURCES= src/register_file.v \
	src/decode_alu.v \
	src/decode_control.v \
	src/hazard_detect.v \
	src/decode_mux.v \
	src/mux_2_1.v \
	src/register_IDEX.v 

all: 

stageIFID:
	$(VC) $(FLAGS)inc -o output/stage_IFID_tb.out $(IFIDSOURCES) test/stage_IFID_tb.v
	vvp output/stage_IFID_tb.out

stageIDEX:
	$(VC) $(FLAGS)inc -o output/stage_IDEX_tb.out $(IDEXSOURCES) test/stage_IDEX_tb.v
	vvp output/stage_IDEX_tb.out