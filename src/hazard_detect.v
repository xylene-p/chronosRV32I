// Chronos Hazard Detection Unit
// Author: Sikender Shahid, Katherine Perez

`include "defines.vh"

module hazard_detect(
	//output
	PC_write, 	// needs to be changed 
	IFID_write,
	Mux_select,
	//inputs
	inst_type,
	IFID_Reg_Rs1,
	IFID_Reg_Rs2,
	IFID_Reg_Rd,
	IDEX_MemRead,
	IDEX_Reg_Rd

	//HDU controlsignal 
	IF_kill, 
	DEC_kill, 
	);

output reg PC_write, IFID_write, Mux_select, IF_kill, DEC_kill;
input [4:0] IFID_Reg_Rs1, IFID_Reg_Rs2, IFID_Reg_Rd, IDEX_Reg_Rd;
input IDEX_MemRead;
input [6:0] inst_type;

always @(*) begin
	case (inst_type)
		`OPCODE_OP: begin// R-type instruction
			if (IDEX_MemRead && (IDEX_Reg_Rd == IFID_Reg_Rs1 ||
								 IDEX_Reg_Rd == IFID_Reg_Rs2 ||
								 IDEX_Reg_Rd == IFID_Reg_Rd))
			begin
				PC_write <= 0;
				IFID_write <= 0;
				Mux_select <= 1;
				IF_kill <= 1; 
				DEC_kill <= 1; 
			end
			else begin
				PC_write <= 1;
				IFID_write <= 1;
				Mux_select <= 0;
				IF_kill <= 0; 
				DEC_kill <= 0; 
			end
		end
		`OPCODE_OP_IMM: begin // I-type instruction
			if (IDEX_MemRead && (IDEX_Reg_Rd == IFID_Reg_Rs1 ||
								 IDEX_Reg_Rd == IFID_Reg_Rd))
			begin
				PC_write <= 0;
				IFID_write <= 0;
 				Mux_select <= 1;
 				IF_kill <= 1; 
				DEC_kill <= 1; 
 			end
 			else begin
 				PC_write <= 1;
 				IFID_write <= 1;
 				Mux_select <= 0;
 				IF_kill <= 0; 
				DEC_kill <= 0; 
 			end
		end
		default: begin
			PC_write <= 1;
			IFID_write <= 1;
			Mux_select <= 0;
			IF_kill <= 0; 
			DEC_kill <= 0; 
		end
	endcase
end
endmodule
