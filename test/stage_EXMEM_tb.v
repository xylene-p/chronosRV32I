`timescale 1ns/1ns

`include "defines.vh"


module stage_EXMEM_tb();
reg clk, rst, en; 
reg [31:0] pc4; 
reg [31:0] opcode1, opcode2;
reg [31:0] instruction; 
reg [4:0] rs2, rd; 
reg [3:0] alu_sel;
reg [2:0] wb_sel; 


initial begin
	$dumpfile("exmem_dump.vcd"); 
	$dumpvars(); 
	$display("test for EXMEM stage, are the correct values latching"); 

	$monitor("pc:[%h] op1:[%h] op2:[%h] alu:[%h]",
		pc4, 
		opcode1, 
		opcode2, 
		stageEXMEM.alu_out); 

	clk <= 1'b1; 
	rst<= 1; 
	en<=1; 

	pc4 = 32'h4; 
	opcode1 = 32'h1; 
	opcode2 = 32'h1;
	alu_sel = `ALU_ADD; 
	wb_sel = `WB_ALU; 

	#10 pc4 = PC44_out; 
	#10 opcode1 = 32'hab324; 
	#10 opcode2 = 32'h43c53;
	#10 alu_sel = `ALU_AND; 

	#100 
	$finish; 
end
always begin
	#5 clk = ~clk; 
end

wire [31:0] alu_out; 
alu _alu(
	.alu_out(alu_out),
	.op1(opcode1),
	.op2(opcode2),
	.alu_sel(alu_sel)); 


branch_gen _branch_gen(
	.inst(instruction),
	.pc(pc4),
	.alu_out(ALUOUT)); 

branch_predictor _branch_predictor(
	.clk(clk),
	.rst(rst), 
	.correct_target(), 
	.correct_pc4(), 
	.current_pc4()); 

wire [31:0] PC44_out;
add_const #(4) pc4Next(
	.out(PC44_out),
	.in(pc4)); 

wire [31:0] ALUOUT; 
mux_2_1 #(32) _wb_sel_mux(
	.out(ALUOUT), 
	.in1(PC44_out),
	.in2(alu_out),
	.sel(1));

register_EXMEM stageEXMEM(
	.alu_out_in(ALUOUT),
	.rs2_in(rs2),
	.instruction_rd_in(rd),
	.clk(clk),
	.rst(rst),
	.en(en),
	//controls to WB
	.register_write_enable_in(0),
	//controls to MEM
	.mem_request_write_in(0),
	.mem_request_type_in(0),
	.wb_sel_in(wb_sel)
	); 


endmodule 