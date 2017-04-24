`timescale 1ns/1ns

module stage_IFID_tb();

reg clk, rst, en;
reg [2:0] pc_sel_in;

initial begin
	$dumpfile("ifid_dump.vcd"); 
	$dumpvars();
	$display("test for IFID stage, are the correct values latching");

	$monitor("PC:[%h] PC+4:[%h] INST:[%h]",
		stageIFID.pc_out,
		stageIFID.pc4_out, 
		stageIFID.instruction_out); 

	clk <= 1'b1; 
	rst <= 1;
	en <= 1; 

	pc_sel_in = 3'b111; //default 
	#10 pc_sel_in = 3'b001; // change in next clock

	#100
	$finish;
end
always begin
	#5 clk = ~clk; 
end

wire [31:0] mux_address_out;
mux_4_1 PCMUX(
    .pc_next(mux_address_out),
    .pc_sel(pc_sel_in),
    .curr_pc4(PCNext_out),
    .branch(),
	.predicted_target());

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

wire [31:0] PCNext_out;
add_const #(4) PCNext(
	.out(PCNext_out),
	.in(PCReg_out)); 

register_IFID stageIFID(
    .pc4_out(),
    .pc_out(),
    .instruction_out(),
    .prediction_out(),
    .pc4_in(PCNext_out),
    .pc_in(PCReg_out),
    .instruction_in(Instruction),
    .prediction_in(0),
    .clk(clk),
    .rst(rst),
    .en(en));
endmodule 