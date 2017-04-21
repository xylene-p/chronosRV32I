module sign_extend(			//comment: needs to be changed, sign extend for I type 
	dataIn, 
	dataControl,
	dataOut); 

input [31:0] dataIn;
input dataControl;
output reg[63:0] dataOut; 

always@(dataIn or dataControl) begin
	if(dataControl)
		dataOut = {{32{dataIn[31]}}, dataIn};
	else begin
		dataOut = {32'b0, dataIn};
	end
end

endmodule 