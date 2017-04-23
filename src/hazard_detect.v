// Chronos Hazard Detection Unit
// Author: Sikender Shahid, Katherine Perez

`include "defines.vh"

module hazard_detect(
	output reg pc_sel,
	output reg IFID_write,
	output reg mux_select,
	output reg kill_IF, 
	output reg kill_DEC,
	input [6:0] opcode,
	input [4:0] IFID_Reg_Rs1,
	input [4:0] IFID_Reg_Rs2,
	input [4:0] IFID_Reg_Rd,
	input [4:0] IDEX_Reg_Rd
	input IDEX_MemRead,
	);

always @(*) begin
	case (opcode)
		`OPCODE_OP: begin// R-type instruction
			if (IDEX_MemRead && (IDEX_Reg_Rd == IFID_Reg_Rs1 ||
								 IDEX_Reg_Rd == IFID_Reg_Rs2 ||
								 IDEX_Reg_Rd == IFID_Reg_Rd))
			begin
				pc_sel <= 0;
				IFID_write <= 0;
				mux_select <= 1;
				kill_IF <= 1; 
				kill_DEC <= 1; 
			end
			else begin
				pc_sel <= 1;
				IFID_write <= 1;
				mux_select <= 0;
				kill_IF <= 0; 
				kill_DEC <= 0; 
			end
		end
		`OPCODE_OP_IMM: begin // I-type instruction
			if (IDEX_MemRead && (IDEX_Reg_Rd == IFID_Reg_Rs1 ||
								 IDEX_Reg_Rd == IFID_Reg_Rd))
			begin
				pc_sel <= 0;
				IFID_write <= 0;
 				mux_select <= 1;
 				kill_IF <= 1; 
				kill_DEC <= 1; 
 			end
 			else begin
 				pc_sel <= 1;
 				IFID_write <= 1;
 				mux_select <= 0;
 				kill_IF <= 0; 
				kill_DEC <= 0; 
 			end
		end
		default: begin
			pc_sel <= 1;
			IFID_write <= 1;
			mux_select <= 0;
			kill_IF <= 0; 
			kill_DEC <= 0; 
		end
	endcase
end
endmodule
