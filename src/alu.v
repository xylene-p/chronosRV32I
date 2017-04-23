`include "defines.vh"

module alu (
	output reg [31:0] alu_out,
	input [31:0] op1,
	input [31:0] op2,
	input [4:0] alu_sel
);
	always @ (*) begin
		case (alu_sel)
			`ALU_ADD:  alu_out = op1 + op2;
			`ALU_SLL:  alu_out = op1 << op2;
			`ALU_SLT:  alu_out = $signed(op1) < $signed(op2) ? 1 : 0;
			`ALU_SLTU: alu_out = op1 < op2 ? 1 : 0;
			`ALU_XOR:  alu_out = op1 ^ op2;
			`ALU_SRL:  alu_out = op1 >> op2;
			`ALU_SRA:  alu_out = $signed(op1) >>> op2;
			`ALU_OR:   alu_out = op1 | op2;
			`ALU_AND:  alu_out = op1 & op2;
			`ALU_LUI:  alu_out = op1 << 12;
			`ALU_NONE: alu_out = 0;
		endcase
	end

endmodule
