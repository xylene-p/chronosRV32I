root=$(pwd)
iverilog -I$root/inc -o output/coreTest.out src/*.v test/*.v
vvp output/coreTest.out
gtkwave core.vcd &
