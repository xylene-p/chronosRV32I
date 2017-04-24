`timescale 1ns/1ns

`include "defines.vh"


module stage_IDEX(); 
reg clk, rst, en; 
reg [31:0] instruction, pc, pc4, nop;

initial begin

	$dumpfile("idex_dump.vcd"); 
	$dumpvars();
	$display("test for IDEX stage, are the correct values latching"); 

	$monitor("PC+4:[%h] PC:[%h] INST:[%h] op1:[%h] op2:[%h] RD:[%b] wb_sel:[%b]", 
        stageIDEX.pc4_out,
        stageIDEX.pc_out, 
        stageIDEX.inst_out,
        stageIDEX.operand1_out,
        stageIDEX.operand2_out,
        stageIDEX.instruction_rd_out,
        stageIDEX.wb_sel_out); 

	clk <= 1'b1; 
	rst<= 1; 
	en<=1; 
    nop <= `INST_NOP;

    pc4 = 32'h4;
    pc = 32'h0;  
	instruction = 32'h00000013;
    #10 pc4 = 32'h8;
    #10 pc = 32'h4;  
	#10 instruction = 32'h00200513;
    #20 pc4 = 32'hc; 
    #20 pc = 32'h8; 
	#20 instruction = 32'h00200593;
	#100
	$finish; 
end
always begin
    #5 clk = ~clk; 
end

wire [31:0] data1; 
wire [31:0] data2; 
register_file reg_file(
    .read_data_1(data1), 
    .read_data_2(data2),
    .rs_1(rs1), 
    .rs_2(rs2),
    .register_write(0), 
    .write_data(0), 
    .register_write_enable(0)); 

wire[3:0] alu_sel;
wire[31:0] op1, op2; 
decode_alu alu_decoder(
    .op1(op1),
    .op2(op2),
    .alu_sel(alu_sel),
    .inst(instruction),
    .rs1(data1),
    .rs2(data2));

wire [4:0] rs1, rs2, rd; 
wire [6:0] opcode; 
wire reg_write_en, mem_req_write, mem_req_type; 
wire [2:0] wb_sel; 
decode_control control_decoder(
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),
    .opcode(opcode),
    .reg_write_en(reg_write_en),
    .wb_sel(wb_sel),
    .mem_req_write(mem_req_write),
    .mem_req_type(mem_req_type),
    .inst(instruction));

wire IF_kill, ID_kill; 
hazard_detect HDU(
    .kill_IF(IF_kill),
    .kill_DEC(ID_kill),
    .regIFID_rs1(rs1),
    .regIFID_rs2(rs2),
    .regIFID_rd(rd),
    .regIDEX_rd(0),
    .memReadIDEX(0));

wire [4:0] rs2_mux, rd_mux;
wire reg_write_en_mux, mem_req_write_mux, mem_req_type_mux;
wire [2:0] wb_sel_mux; 
decode_mux mux_decode(
    .rs2_out(rs2_mux),
    .rd_out(rd_mux),
    .reg_write_en_out(reg_write_en_mux), 
    .wb_sel_out(wb_sel_mux), 
    .mem_req_write_out(mem_req_write_mux), 
    .mem_req_type_out(mem_req_type_mux),
    .rs2_in(rs2), 
    .rd_in(rd), 
    .reg_write_en_in(reg_write_en), 
    .wb_sel_in(wb_sel), 
    .mem_req_write_in(mem_req_write), 
    .mem_req_type_in(mem_req_type),
    .kill_DEC(ID_kill),
    .nop(nop));

wire [3:0] alu_sel_mux; 
mux_2_1 #(4) alu_decode_mux(
    .out(alu_sel_mux),
    .in1(alu_sel),
    .in2(nop[3:0]),
    .sel(ID_kill));

register_IDEX stageIDEX(
    .clk(clk),
    .rst(rst),
    .en(en),
    .pc4_in(pc4),
    .pc_in(pc),
    .inst_in(instruction),
    .operand1_in(op1),
    .operand2_in(op2),
    .instruction_rd_in(rd_mux),
    .rs2_in(rs2_mux),
    .prediction_in(0),
    //controls to WB
    .register_write_enable_in(reg_write_en_mux),
    //controls to MEM
    .mem_request_write_in(mem_req_write_mux),
    .mem_request_type_in(mem_req_type_mux),
    //control to EXE
    .alu_sel_in(alu_sel_mux),
    .wb_sel_in(wb_sel_mux)); 
endmodule 