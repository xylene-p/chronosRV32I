`timescale 1 ns/1 ns
`define MEM_CMD_READ	1'b0
`define MEM_CMD_WRITE	1'b1

module TestBench();

	reg clk;
	reg mem_reset;
	
	reg [31:0] datamem_addr;
    reg [31:0] datamem_instruction;
	// reg [3:0] mem_mask;
	reg mem_enable;

	wire mem_cmd;
	reg [31:0] datamem_data, datamem_load_data;
	wire [31:0] mem_load_data;
	wire mem_valid;
    wire [3:0] datamem_write_mask;
    wire [31:0] mem_addr,mem_write_data;

    data_memory datamem(datamem_instruction, datamem_data, datamem_addr, mem_addr, mem_cmd, mem_write_data, datamem_write_mask, datamem_load_data, mem_load_data);


	mem memory(clk,mem_reset,mem_addr,datamem_write_mask,mem_enable,mem_cmd,mem_write_data,mem_load_data,mem_valid);


	always begin
        clk <= 0;
        #10;
        clk <= 1;
        #10;
    end

    initial begin
    	mem_reset <= 1;
        datamem_instruction <= 32'b00000000000000000000000100000000;
    	datamem_addr <= 32'b000000000000000000000000010100;
    	// mem_mask <= 4'b1111;
    	mem_enable <= 0;
    	#50
    	mem_reset <= 0;
    	#30
    	datamem_data <= 32'b00000000000000001111111111111111;
    	// mem_cmd = `MEM_CMD_WRITE;
    	#10
    	mem_enable = 1;
    	// #100
    	// mem_enable = 0;
    	// #10
    	// mem_cmd = `MEM_CMD_READ;
    	// #10
    	// mem_enable = 1;
    end

endmodule
