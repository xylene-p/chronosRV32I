module stage_IDEX(); 
reg clk, rst, en; 
reg [31:0] instruction; 
initial begin
	$dumpfile("idex_dump.vcd"); 
	$dumpvars();
	$display("test for IDEX stage, are the correct values latching"); 

	$monitor("INST:[%b] ", instruction); 

	clk <= 1'b1; 
	rst<= 1; 
	en<=1; 

	instruction = 00000013;
	#10 instruction = 00200513;
	#20 instruction = 00200593;

	#100
	$finish; 
end
	register_IDEX IDEXRegister(
    .pc4_out(pc4_IDEX_out),
    .pc_out(pc_IDEX_out),
    .inst_out(inst_IDEX_out),
    .operand1_out(op1_IDEX_out),
    .operand2_out(op2_IDEX_out),
    .instruction_rd_out(inst_rd_IDEX_out),
    .prediction_out(prediction_IDEX_out),
    .register_write_enable_out(reg_write_en_IDEX_out),
    .mem_request_write_out(mem_req_write_IDEX_out),
    .mem_request_type_out(mem_req_type_IDEX_out),
    .alu_sel_out(alu_sel_IDEX_out),
    .wb_sel_out(wb_sel_IDEX_out),
    .IDEXRegRead_out(reg_read_IDEX_out),
    .IDEXMemRead(mem_read_IDEX_out),
    .rs2_out(rs2_IDEX_out),
    .clk(clk),
    .rst(rst),
    .en(en),
    .pc4_in(pc4_IFID_out),
    .pc_in(pc_IFID_out),
    .operand1_in(alu_op1),
    .operand2_in(alu_op2),
    .instruction_rd_in(dcd_rd),
    .rs2_in(dcd_rs2),
    .prediction_in(branch_prediction),
    .register_write_enable_in(reg_write_en),
    .mem_request_write_in(dcd_mem_req_type),
    .mem_request_type_in(dcd_mem_req_write),
    .alu_sel_in(alu_sel),
    .wb_sel_in(wb_sel));

endmodule 