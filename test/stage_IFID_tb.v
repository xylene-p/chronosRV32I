`timescale 1ns/1ns

module stage_IFID_tb();

reg clk, rst, en; 
reg [31:0] mux_address_out; 


initial begin
	$dumpfile("ifid_dump.vcd"); 
	$dumpvars();
	$display("test for IFID stage, are the correct values latching");

	$monitor("PC:[%h] INST:[%h]",
		stageIFID.pc_out, 
		stageIFID.instruction_out); 
	clk <= 1'b1; 
	rst <= 1; // active low 
	en <= 1; 
	mux_address_out = 32'h4; 
	#10 mux_address_out = 32'h8; 
	#20 mux_address_out = 32'hC; 
	#30 mux_address_out = 32'h10;

	#40
	#60

	$finish;
end
always begin
	#5 clk = ~clk; // toggle every 5 clock delays
end
// mux_4_1 PCMUX(
//     .pc_next(fetch_addr),
//     .pc_sel(pc_sel),
//     .curr_pc4(fetch_addr_next),
//     .branch(branch_target),
//     .predicted_target(branch_predicted_target));

wire [31:0] PCReg_out; 
register_pc PCReg(
    .q(PCReg_out),
    .d(mux_address_out),
    .en(en),
    .clk(clk),
    .rst(rst));

wire [31:0] Instruction; 
inst_mem InstMem(
    .request_data(Instruction),
    .address(PCReg_out),
    .clk(clk),
    .rst(rst),
    .wb_en(0), 
    .wb_address(32'b0), 
    .wb_data(32'b0));

register_IFID stageIFID(
    .pc4_out(),
    .pc_out(),
    .instruction_out(),
    .prediction_out(),
    .pc4_in(0),
    .pc_in(PCReg_out),
    .instruction_in(Instruction),
    .prediction_in(0),
    .clk(clk),
    .rst(rst),
    .en(en)); // IFIDWRITE FROM HAZARD 
endmodule 