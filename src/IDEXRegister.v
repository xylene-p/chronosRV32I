module IDEXRegister(
	PC8_in, 
	rData1_out, 
	rData2_out, 
	PC8_in,  
	rData1_in, 
	rData2_in, 
	clk,
	rst,
	en,
	);

input [31:0] PC8_in; 
output reg [31:0] PC8_out; 

always@(posedge clk) begin
	if(rst)begin
		rData1_out = 0; 
		rData2_out = 0; 
		PC8_out = 0; 
	end
	else if(en)begin
		rData2_out <= rData2_in; 
		rData1_out <= rData1_in; 
		PC8_out <= PC8_in; 
	end
end

endmodule

