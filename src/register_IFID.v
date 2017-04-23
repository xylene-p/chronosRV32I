module register_IFID(
	output reg [31:0] pc4_out, 
	output reg [31:0] instruction_out,
	output reg prediction_out, 
	input [31:0] pC4_in, 
	input [31:0] instruction_in, 
	input prediction_in, 
	input clk, 
	input rst,
	input en); 

always@(posedge clk)begin

	if(~rst)begin

		pc4_out = 0; 
		instruction_out =0;
		prediction_out =0; 
	end
	if(en)begin

		pc4_out <= pc4_in; 
		instruction_out <= instruction_in;
		prediction_out <= prediction_in;  
	end
end

endmodule 