`timescale 1ns/1ns

`include "defines.vh"

module stage_MEMWB_tb();
reg clk, rst, en; 
initial begin
	$dumpfile("memwb_dump.vcd"); 
	$dumpvars(); 
	$display("test for MEMEX stage, are the correct values latching"); 

	// this one should show before and after MEMWB
	//$monitor("", );
	
	clk <= 1'b1; 
	rst<= 1; 
	en<=1; 

	#100
	$finish; 
end
always begin
	#5 clk = ~clk; 
end

writeback _writeback(
	.output_data(), 
	.out_data_mem(), 
	.out_pc4(), 
	.out_alu(), 
	.wb_sel()); 


data_memory _data_memory(
	.memory_addr(), 
	.write_data(), 
	.write_mask(), 
	.output_data(),
	.instruction(), 
	.data(), 
	.addr(), 
	.load_data()); 

simulated_mem _simulated_mem(
	.load_data(), 
	.valid(),
	.clk(),
	.reset(), 
	.addr(), 
	.mask(), 
	.enable(), 
	.cmd(), 
	.write_data());

register_MEMWB _register_MEMWB(
	.wb_data_out(), 
	.instruction_rd_out(), 
	.register_write_enable_out(), 
	.wb_data_in(), 
	.instruction_rd_in(), 
	.clk(), 
	.rst(), 
	.en(),
	.register_write_enable_in());

register_file _register_file(
	.register_write(), 
	.write_data(), 
	.register_write_enable()); 

endmodule 