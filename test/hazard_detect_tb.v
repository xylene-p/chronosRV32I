`timescale 1ns/1ns

module hazard_detect_tb();

reg clk, memReadIDEX_in; 
reg [6:0] opcode_in; 
reg [4:0] IFID_rs1, IFID_rs2, IFID_rd, IDEX_rd; 
reg [31:0] instruction; 

initial begin
	$dumpfile("hazard_dump.vcd"); 
	$dumpvars(); 
	$display("Hazard Detect Simulation");

	$monitor ("clock:[%b] INST:[%h] IDEX:[%h] IFIDrd:[%h] IFIDrs1:[%h] IFIDrs2:[%h] IFKILL:[%h] IDKILL:[%h]", 
		clk,
		instruction, 
		IDEX_rd, 
		_hazard_detect.regIFID_rd, 
		IFID_rs1, 
		IFID_rs2, 
		IF_KILL, 
		ID_KILL);

	clk <= 1'b1; 
	instruction <= 32'h00000013; 
	opcode_in <= instruction[6:0]; 
	IFID_rs1 <= instruction[19:15]; 
	IFID_rs2 <= instruction[24:20]; 
	IFID_rd <= instruction[11:7]; 
	#5
	if(ID_KILL == 0)begin
		IDEX_rd <= IFID_rd; 
		memReadIDEX_in = 1; 
	end

	//instruction 1
	instruction <= 32'h00200513;
	opcode_in <= instruction[6:0]; 
	IFID_rs1 <= instruction[19:15]; 
	IFID_rs2 <= instruction[24:20]; 
	IFID_rd <= instruction[11:7];
	#5
	if(ID_KILL == 0)begin
		IDEX_rd <= IFID_rd; 
		memReadIDEX_in = 1; 
	end

	//instruction 2
	instruction <= 32'h00200593;
	opcode_in <= instruction[6:0]; 
	IFID_rs1 <= instruction[19:15]; 
	IFID_rs2 <= instruction[24:20]; 
	IFID_rd <= instruction[11:7];
	#5
	if(ID_KILL == 0)begin
		IDEX_rd <= IFID_rd; 
		memReadIDEX_in = 1; 
	end

	//instruction 3
	instruction <= 32'h00b50463;
	opcode_in <= instruction[6:0]; 
	IFID_rs1 <= instruction[19:15]; 
	IFID_rs2 <= instruction[24:20]; 
	IFID_rd <= instruction[11:7];
	#5
	if(ID_KILL == 0)begin
		IDEX_rd <= IFID_rd; 
		memReadIDEX_in = 1; 
	end

	#50
	$finish; 
end
always begin
	#5 clk = ~clk; 
end

wire IF_KILL, ID_KILL; 
hazard_detect _hazard_detect(
	.kill_IF(IF_KILL), 
	.kill_DEC(ID_KILL), 
	.opcode(opcode_in), 
	.regIFID_rs1(IFID_rs1), 
	.regIFID_rs2(IFID_rs2), 
	.regIFID_rd(IFID_rd), 
	.regIDEX_rd(IDEX_rd), 
	.memReadIDEX(memReadIDEX_in)); 


endmodule 