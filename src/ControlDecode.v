`include "defines.vh"

module ControlDecode (
	//OUTPUT CONTROLS 
	Alu_fun; 
	wb_sel; 
	regWriteEn; 
	mem_rw; 
	mem_val; 
	IDEXrd; 

	Op2Sel; // sent to ALU DECODE 


	//input
	Instruction_in; 					// comment : we might just need opcode 
	);

output reg Alu_fun, wb_sel, regWriteEn, mem_rw, mem_val, IR_kill, Dec_kill; 

input [31:0] Instruction_in; 
wire [6:0] opcode = Instruction_in[6:0]; // comment: reminder lines not needed. 
wire [4:0] IDEXrd = Instruction_in[11:7]; 

always@(opcode) begin
	case(opcode)
		`OPCODE_OP: begin

			Op2Sel = 0; 
		end
		`OPCODE_OP_IMM: begin

			Op2Sel = 1; 
		end
										// comment: more need to be added. 
end




endmodule 