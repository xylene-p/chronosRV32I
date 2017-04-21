module IDEXRegister(				// comment : Not done
//output
	PC4_out, 
	Operand1_out, 
	Operand2_out, 
	PC4_in,  
	Operand1_in, 
	Operand2_in, 
	//controls to WB
	wb_sel_out; 
	register_write_enable_out; 
	//controls to MEM
	mem_rw_out; 
	mem_val_out; 
	wb_sel_out; 
	//control to EXE
	Alu_fun_out; 
	wb_sel_out;
	//HazardControlUnit outputs
	IDEXRegRead; 
	IDEXMemRead;

//inputs
	clk, 
	rst, 
	en,
	//controls to WB
	wb_sel_in; 
	register_write_enable_in; 
	//controls to MEM
	mem_rw_in; 
	mem_val_in; 
	wb_sel_in; 
	//control to EXE
	Alu_fun_in; 
	wb_sel_in;
	);

input [31:0] PC4_in; 
output reg [31:0] PC4_out; 

always@(posedge clk) begin
	if(rst)begin
		Operand1_out = 0; 
		Operand2_out = 0; 
		PC4_out = 0; 
	end
	else if(en)begin
		Operand2_out <= Operand2_in; 
		Operand1_out <= Operand1_in; 
		PC4_out <= PC4_in; 
	end
end

endmodule

