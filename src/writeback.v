module writeback(output_data,out_data_mem,out_pc4,out_alu,wb_sel);
	
	output [31:0] output_data;
	input[2:0] wb_sel,
	input [31:0] out_data_mem,out_pc4,out_alu;
	always@(wb_sel) begin
		case(wb_sel)
			0: output_data <= out_pc4;
			1: output_data <= out_alu;
			2: output_data <= out_data_mem;
		endcase
	end
endmodule