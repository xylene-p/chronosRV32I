// Decoder Module
// Author: Katherine Perez

`include "defines.vh"

// rs1          (output) register source 1
// rs2          (output) register source 2
// reg_write_en (output) register write enable
// wb_sel       (output) write back select
// inst         (input)  instruction
module decode(
    // outputs
    rs1, rs2, rd, reg_write_en, wb_sel,
    // inputs
    inst
    );

    output [4:0] rs1, rs2, rd;
    output reg_write_en;
    output reg wb_sel;
    input [31:0] inst;
    wire [6:0] opcode;

    assign rs2 = inst[24:20];
    assign rs1 = inst[19:15];
    assign rd  = inst[11:7];

    assign reg_write_en = (opcode == `OPCODE_OP ||
                           opcode == `OPCODE_OP_IMM ||
                           opcode == `OPCODE_LUI ||
                           opcode == `OPCODE_LOAD ||
                           opcode == `OPCODE_JAL ||
                           opcode == `OPCODE_JALR ||
                           opcode == `OPCODE_SYS);

    always @ (*) begin
        case (opcode)
			`OPCODE_OP, `OPCODE_OP_IMM, `OPCODE_LUI:
				wb_sel = `WB_ALU;
			`OPCODE_LOAD:
				wb_sel = `WB_MEM;
			`OPCODE_JAL, `OPCODE_JALR:
				wb_sel = `WB_PC4;
			`OPCODE_SYS:
				wb_sel = `WB_SYS;
			default:
				wb_sel = 0;
		endcase
	end


endmodule
