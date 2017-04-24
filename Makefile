# root_dir = $(shell pwd)
# IV_FLAGS = 

VC=iverilog
FLAGS=-I

SOURCES= src/register_pc.v \
src/inst_mem.v \
src/register_IFID.v \
src/add_const.v \
src/mux_4_1.v

all: 

stageIFID:
	$(VC) $(FLAGS)inc -o output/stage_IFID_tb.out $(SOURCES) test/stage_IFID_tb.v
	vvp output/stage_IFID_tb.out