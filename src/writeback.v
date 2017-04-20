module wb(output_data,out_data_mem,out_pc4,out_alu,wb_sel,clk)
	
	output [31:0] output_data;
	input[1:0] wb_sel,
	input clk;
	input [31:0] out_data_mem,out_pc4,out_alu;
	
	always@(posedge clk)begin
		case(wb_sel)
			0: output_data <= out_pc4;
			1: output_data <= out_alu;
			2: output_data <= out_data_mem;
		endcase
	end
endmodule



module wa(output_data,ir_data,clk,wa_sel)

	output [3:0] output_data;
	input clk,wa_sel;
	input [3:0] ir_data;

	always @(posedge clk)begin

		if(wa_sel) begin
			output_data <= ir_data;
		end
		else begin
			output_data <= 1;
		end
	end
endmodule