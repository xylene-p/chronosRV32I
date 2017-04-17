iverilog -I/home/exmachina/chronosRV32I/inc -o output/coreTest src/*.v test/*.v
vvp output/coreTest
