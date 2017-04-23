module register_IDEX(				// comment : Not done
//output
	output reg [31:0] pc4_out, 
	output reg [31:0] operand1_out, 
	output reg [31:0] operand2_out,
	output reg [4:0] instruction_rd_out,
	output reg prediction_out,
	//controls to WB 
	output reg register_write_enable_out,
	//controls to MEM
	output reg mem_request_write_out,
	output reg mem_request_type_out, 
	//control to EXE
	output reg alu_sel_out,
	output reg [2:0] wb_sel_out,
	//HazardControlUnit outputs
	output reg [4:0] IDEX_RegRead_out,
	output reg IDEXMemRead,
//inputs
	input clk, 
	input rst, 
	input en,
	input [31:0] pc4_in,  
	input [31:0] operand1_in, 
	input [31:0] operand2_in,
	input [4:0] instruction_rd_in, 
	input prediction_in, 
	//controls to WB
	input wb_sel_in, 
	input register_write_enable_in,
	//controls to MEM
	input mem_request_write_in,
	input mem_request_type_in, 
	//control to EXE
	input [3:0] alu_sel_in, 
	input [2:0] wb_sel_in,
	);

always@(posedge clk) begin
	if(~rst)begin
		operand1_out = 0; 
		operand2_out = 0; 
		pc4_out = 0; 
		instruction_rd_out = 0;
		//signal to hazard control unit
		IDEXMemRead = 0; 
		IDEXRegRead_out = 0; 
		//controls to WB
		wb_sel_out  = 0 ; 
		register_write_enable_out =0; 
		//controls to MEM
		mem_request_write_out  = 0; 
		mem_request_type_out = 0; 
		//control to EXE
		alu_sel_out = 0; 
		wb_sel_out = 3'b0;
	end
	else if(en)begin
		operand2_out <= operand2_in; 
		operand1_out <= operand1_in; 
		pc4_out <= pc4_in;
		instruction_rd_out <= instruction_rd_in; 
		//signal to hazard control unit
		IDEXMemRead = 1; 
		IDEXRegRead_out <= instruction_rd_in;
		//controls to WB
		wb_sel_out  <= wb_sel_in ; 
		register_write_enable_out = register_write_enable_in; 
		//controls to MEM
		mem_request_write_out  <= mem_request_write_in; 
		mem_request_type_out <= mem_request_type_in;
		//control to EXE
		alu_sel_out <= alu_sel_in; 
		wb_sel_out <= wb_sel_in;
	end
end

endmodule

