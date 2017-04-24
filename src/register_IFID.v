module register_IFID(
	output reg [31:0] pc4_out,
	output reg [31:0] pc_out,
	output reg [31:0] instruction_out,
	output reg prediction_out,
	input [31:0] pc4_in,
	input [31:0] pc_in,
	input [31:0] instruction_in,
	input prediction_in,
	input clk,
	input rst,
	input en);

always@(posedge clk)begin
	if (rst != 0 && en == 1) begin
		pc4_out <= pc4_in;
		pc_out <= pc_in;
		instruction_out <= instruction_in;
		prediction_out <= prediction_in;
	end
	else begin
		pc4_out = 0;
		pc_out = 0;
		instruction_out = 0;
		prediction_out = 0;
	end
end
endmodule
