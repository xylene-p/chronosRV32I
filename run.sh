iverilog -I/home/exmachina/chronosRV32I/inc -o output/coreTest.out src/*.v test/*.v
vvp output/coreTest.out
gtkwave core.vcd &
