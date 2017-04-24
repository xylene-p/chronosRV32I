`timescale 1ns/1ns

`include "defines.vh"


module stage_EXMEM_tb();
reg clk, rst, en; 


initial begin
	$dumpfile("exmem_dump.vcd"); 
	$dumpvars(); 
	$display("test for EXMEM stage, are the correct values latching"); 

	$monitor("", ); 

	
	#100 
	$finish; 
end
always begin
	#5 clk = ~clk; 
end

endmodule 