`timescale 1 ns/1 ns
`define MEM_CMD_READ	1'b0
`define MEM_CMD_WRITE	1'b1

module TestBench();

	reg clk;
	reg reset;
	
	reg [31:0] addr;
	reg [3:0] mask;
	reg enable;

	reg cmd;
	reg [31:0] write_data;
	wire [31:0] load_data;
	wire valid;


	mem memory(clk,reset,addr,mask,enable,cmd,write_data,load_data,valid);

	always begin
        clk <= 0;
        #10;
        clk <= 1;
        #10;
    end

    initial begin
    	reset <= 1;
    	addr <= 0;
    	mask <= 4'b1111;
    	enable <= 0;
    	#50
    	reset <= 0;
    	#30
    	write_data <= 32'b00000000000000001111111111111111;
    	cmd = `MEM_CMD_WRITE;
    	#10
    	enable = 1;
    	#100
    	enable = 0;
    	#10
    	cmd = `MEM_CMD_READ;
    	#10
    	enable = 1;
    end

endmodule
