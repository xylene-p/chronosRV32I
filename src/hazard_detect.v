// Chronos Hazard Detection Unit
// Author: Sikender Shahid, Katherine Perez

`include "defines.vh"

module hazard_detect(
	output reg kill_IF,
	output reg kill_DEC,
	input [6:0] opcode,
	input [4:0] regIFID_rs1,
	input [4:0] regIFID_rs2,
	input [4:0] regIFID_rd,
	input [4:0] regIDEX_rd,
	input memReadIDEX);

always @(*) begin
	if (memReadIDEX && (regIDEX_rd == regIFID_rs1 ||  // if this true rest wont matter for immediate
						 regIDEX_rd == regIFID_rs2 ||
						 regIDEX_rd == regIFID_rd)) begin
		kill_IF <= 1;
		kill_DEC <= 1;
	end
	else begin
		kill_IF <= 0;
		kill_DEC <= 0;
		end
end
endmodule
