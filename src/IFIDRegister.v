module IFIDRegister(
	output reg [31:0] PC4_out, 
	output reg [31:0] Instruction_out,
	output reg Prediction_out, 
	input [31:0] PC4_in; 
	input [31:0] Instruction_in, 
	input Prediction_in, 
	input clk, 
	input rst,
	input en); 

always@(posedge clk)begin

	if(rst)begin

		PC4_out = 0; 
		Instruction_out =0; 
	end
	if(en)begin

		PC4_out <= PC4_in; 
		Instruction_out <= Instruction_in; 
	end
end

endmodule 