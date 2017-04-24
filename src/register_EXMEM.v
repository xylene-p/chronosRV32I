module register_EXMEM(				// comment : not done;
//output
	output reg [31:0] alu_out,
	output reg [4:0] rs2_out,
	output reg [4:0] instruction_rd_out,
	//controls to WB
	output reg register_write_enable_out,
	//controls to MEM
	output reg mem_request_write_out,
	output reg mem_request_type_out,
	output reg [2:0] wb_sel_out,
//input
	input [31:0] alu_out_in,
	input [4:0] rs2_in,
	input [4:0] instruction_rd_in,
	input clk,
	input rst,
	input en,
	//controls to WB
	input register_write_enable_in,
	//controls to MEM
	input mem_request_write_in,
	input mem_request_type_in,
	input [2:0] wb_sel_in);

always@(posedge clk) begin
	if(rst == 0)begin
		alu_out = 0;
		rs2_out = 0;
		instruction_rd_out = 0;
		//controls to WB
		wb_sel_out = 0;
		register_write_enable_out = 0;
		//controls to MEM
		mem_request_write_out = 0;
		mem_request_type_out = 0;
		wb_sel_out = 3'b0;
	end
	else if(en == 0) begin
		alu_out <= alu_out_in;
		rs2_out <= rs2_in;
		instruction_rd_out <= instruction_rd_in;
		//controls to WB
		wb_sel_out <= wb_sel_in;
		register_write_enable_out <= register_write_enable_in;
		//controls to MEM
		mem_request_write_out <= mem_request_write_in;
		mem_request_type_out <= mem_request_type_in;
		wb_sel_out <= wb_sel_in;

	end
end



endmodule
