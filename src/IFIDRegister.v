module IFIDRegister(
	PC4_out, 
	Instruction_out,
	PC4_in, 
	Instruction_in, 
	clk, 
	rst,
	en); 

input [31:0] PC4_in, Instruction_in; 
input clk, rst, en; 
output reg [31:0] PC4_out, Instruction_out; 

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