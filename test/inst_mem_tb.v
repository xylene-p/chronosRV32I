`timescale 1ns/1ns


module inst_mem_tb();

reg clk, rst, en; 
reg [31:0] address; 
reg address_request; 
wire [31:0] address_out; 
wire fetch_data_valid_out; 


inst_mem _instruction_mem(
	.request_data(address_out),
	.fetch_data_valid(fetch_data_valid_out), 
	.fetch_addr(address), 
	.fetch_req(address_request), 
	.clk(clk), 
	.rst(rst)); 


initial begin
	$dumpfile("inst_mem.vcd"); 
	$dumpvars();
	$display("first test- view first instruction"); 

	$monitor("clk:[%b] PC:[%b] Index:[%b] Output Address:[%h]", clk,
		address,
		_instruction_mem.inst_addr,
		_instruction_mem.request_data);


	address = 32'b0;
	clk <= 1'b1; 
	en <= 1'b1; 
	rst<= 1'b1; 
	address_request <= 1'b1; 
	#10 address = 32'h4;
	#15 address = 32'h8; 
	#20 address = 32'hC; 

	 
	if(fetch_data_valid_out == 1'b1 && address_out == 32'h13)
		$display("PASSED");
	#100 $finish;
end

always begin
	#5 clk = ~clk; // toggle every 5 clock delays
end

endmodule 
