	// Chronos Hazard Detection Unit
// Author: Sikender Shahid, Katherine Perez

`include "defines.vh"

module hazard_detect(
	output reg [2:0] pc_sel,
	output reg IFID_write,
	output reg mux_select,
	output reg kill_IF,
	output reg kill_DEC,
	input [6:0] opcode,
	input [4:0] regIFID_rs1,
	input [4:0] regIFID_rs2,
	input [4:0] regIFID_rd,
	input [4:0] regIDEX_rd,
	input memReadIDEX);

always @(*) begin
	case (opcode)
		`OPCODE_OP: begin// R-type instruction
			if (memReadIDEX && (regIDEX_rd == regIFID_rs1 ||
								 regIDEX_rd == regIFID_rs2 ||
								 regIDEX_rd == regIFID_rd))
			begin
				pc_sel <= 3'b000;
				IFID_write <= 0;
				mux_select <= 1;
				kill_IF <= 1;
				kill_DEC <= 1;
			end
			else begin
				pc_sel <= 3'b001;
				IFID_write <= 1;
				mux_select <= 0;
				kill_IF <= 0;
				kill_DEC <= 0;
			end
		end
		`OPCODE_OP_IMM: begin // I-type instruction
			if (memReadIDEX && (regIDEX_rd == regIFID_rs1 ||
								 regIDEX_rd == regIFID_rd))
			begin
				pc_sel <= 3'b000;
				IFID_write <= 0;
 				mux_select <= 1;
 				kill_IF <= 1;
				kill_DEC <= 1;
 			end
 			else begin
 				pc_sel <= 3'b001;
 				IFID_write <= 1;
 				mux_select <= 0;
 				kill_IF <= 0;
				kill_DEC <= 0;
 			end
		end
		default: begin
			pc_sel <= 3'b001;
			IFID_write <= 1;
			mux_select <= 0;
			kill_IF <= 0;
			kill_DEC <= 0;
		end
	endcase
end
endmodule
