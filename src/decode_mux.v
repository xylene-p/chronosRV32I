module decode_mux(
	//output
	output reg [4:0] rs2_out,
	output reg [4:0] rd_out,
	output reg reg_write_en_out, 
	output reg [2:0] wb_sel_out, 
    output reg mem_req_write_out, 
    output reg mem_req_type_out,
    //input 
    input [4:0] rs2_in, 
    input [4:0] rd_in, 
    input reg_write_en_in, 
	input [2:0] wb_sel_in, 
    input mem_req_write_in, 
    input mem_req_type_in,
    input kill_DEC,
    input [31:0] nop);


always@(kill_DEC) begin
	if(kill_DEC == 1)begin
		rs2_out <= nop;
		rd_out<= nop;
		reg_write_en_out<= nop;
		wb_sel_out<= nop;
    	mem_req_write_out<= nop;
    	mem_req_type_out<= nop;
	end
	else begin
		rs2_out <= rs2_in;
		rd_out<= rd_in;
		reg_write_en_out<= reg_write_en_in;
		wb_sel_out<= wb_sel_in;
    	mem_req_write_out<= mem_req_write_in;
    	mem_req_type_out<= mem_req_type_in;
	end
end
endmodule  

