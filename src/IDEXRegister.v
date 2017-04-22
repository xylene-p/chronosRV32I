module IDEXRegister(				// comment : Not done
//output
	output reg [31:0] PC4_out, 
	output reg [31:0] Operand1_out, 
	output reg [31:0] Operand2_out, 
	 
	//controls to WB
	output reg wb_sel_out; 
	output reg register_write_enable_out; 
	//controls to MEM
	output reg mem_rw_out; 
	output reg mem_val_out; 
	output reg wb_sel_out; 
	//control to EXE
	output reg Alu_sel_out; 
	output reg wb_sel_out;
	//HazardControlUnit outputs
	output reg [4:0] IDEXRegRead_out; 
	output reg IDEXMemRead;

//inputs
	input clk, 
	input rst, 
	input en,
	input [31:0] PC4_in,  
	input [31:0] Operand1_in, 
	input [31:0] Operand2_in,
	//controls to WB
	input wb_sel_in; 
	input register_write_enable_in; 
	//controls to MEM
	input mem_rw_in; 
	input mem_val_in; 
	input wb_sel_in; 
	//control to EXE
	input [3:0] Alu_sel_in; 
	input wb_sel_in;
	//Hazard Control unit input 
	input [4:0] IDEXRegRead_in; 
	);

always@(posedge clk) begin

	if(rst)begin

		Operand1_out = 0; 
		Operand2_out = 0; 
		PC4_out = 0; 

		//signal to hazard control unit
		IDEXMemRead = 0; 
		IDEXRegRead_out = 0; 

		//controls to WB
		wb_sel_out  = 0 ; 
		register_write_enable_out =0; 
		//controls to MEM
		mem_rw_out  = 0; 
		mem_val_out = 0; 
		wb_sel_out  = 0; 
		//control to EXE
		Alu_sel_out = 0; 
		wb_sel_out = 0;


	end
	else if(en)begin
		Operand2_out <= Operand2_in; 
		Operand1_out <= Operand1_in; 
		PC4_out <= PC4_in;

		//signal to hazard control unit
		IDEXMemRead = 1; 
		IDEXRegRead_out <= IDEXRegRead_in;

		//controls to WB
		wb_sel_out  <= wb_sel_in ; 
		register_write_enable_out = register_write_enable_in; 
		//controls to MEM
		mem_rw_out  <= mem_rw_in; 
		mem_val_out <= mem_val_in;
		wb_sel_out  <= wb_sel_in; 
		//control to EXE
		Alu_sel_out <= Alu_sel_in; 
		wb_sel_out <= wb_sel_in;
	end
end

endmodule

