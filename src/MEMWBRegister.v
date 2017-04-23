module MEMWBRegister(
//outputs
	output reg [31:0] WBData_out; 
	//controls to WB
	output reg wb_sel_out; 
	output reg register_write_enable_out;
	output reg [4:0] InstructionRd_out;  

//inputs
	input [31:0] WBData_in; 
	input [4:0] InstructionRd_in; 

	input clk; 
	input rst; 
	input en; 
	//controls to WB
	input wb_sel_in; 
	input register_write_enable_in; 
	); 

always@(posedge clk) begin

	if(rst) begin

		WBData_out = 0; 
		//controls to WB
		wb_sel_out = 0; 
		register_write_enable_out = 0; 

		InstructionRd_out =0;
	end
	else if(en) begin
		wb_sel_out <= wb_sel_in; 
		WBData_out <= WBData_in; 
		register_write_enable_out <= register_write_enable_in; 

		InstructionRd_out <= InstructionRd_in;
		
	end
end

endmodule 