module register_MEMWB(
//outputs
	output reg [31:0] wb_data_out, 
	output reg [4:0] instruction_rd_out,
	//controls to WB
	output reg register_write_enable_out,
//inputs
	input [31:0] wb_data_in,
	input [4:0] instruction_rd_in, 
	input clk, 
	input rst, 
	input en,
	//controls to WB
	input register_write_enable_in,
	); 

always@(posedge clk) begin
	if(~rst) begin
		instruction_rd_out =0;
		wb_data_out = 0; 
		//controls to WB 
		register_write_enable_out = 0;
	end
	else if(en) begin
		instruction_rd_out <= instruction_rd_in;
		wb_data_out <= wb_data_in; 
		//controls to WB 
		register_write_enable_out <= register_write_enable_in; 	
	end
end
endmodule 