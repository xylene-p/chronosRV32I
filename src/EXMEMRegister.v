module EXMEMRegister(				// comment : not done; 
//output
	output reg [31:0] ALUOUT_out; 
	output reg [31:0] RS2_out;

	//controls to WB
	output reg wb_sel_out; 
	output reg register_write_enable_out; 
	//controls to MEM
	output reg mem_rw_out; 
	output reg mem_val_out; 
	output reg wb_sel_out; 
//input
	input [31:0] ALUOUT_in; 
	input [31:0] RS2_in;
 
	input clk; 
	input rst; 
	input en; 
	//controls to WB
	input wb_sel_in; 
	input register_write_enable_in; 
	//controls to MEM
	input mem_rw_in; 
	input mem_val_in; 
	input wb_sel_in; 
	);

always@(posedge clk) begin
	if(rst)begin
		ALUOUT_out = 0; 
		RS2_out = 0;

		//controls to WB
		wb_sel_out = 0; 
		register_write_enable_out = 0; 
		//controls to MEM
		mem_rw_out = 0; 
		mem_val_out = 0; 
		wb_sel_out = 0; 
	end
	else if(en) begin
		ALUOUT_out <= ALUOUT_in; 
		RS2_out <= RS2_in;

		//controls to WB
		wb_sel_out <= wb_sel_in; 
		register_write_enable_out <= register_write_enable_in; 
		//controls to MEM
		mem_rw_out <= mem_rw_in; 
		mem_val_out <= mem_val_in; 
		wb_sel_out <= wb_sel_in; 
	end
end



endmodule 