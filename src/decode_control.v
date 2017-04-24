// Decoder Module
// Author: Katherine Perez

`include "defines.vh"

// rs1          (output) register source 1
// rs2          (output) register source 2
// reg_write_en (output) register write enable
// wb_sel       (output) write back select
// inst         (input)  instruction
module decode_control(
    // outputs
    rs1, rs2, rd, 
 //   imm12, 
    reg_write_en, wb_sel, opcode, 
 //   funct7,
    mem_req_write, mem_req_type,
    // inputs
    inst);

    output [4:0] rs1, rs2, rd;
    output [11:0] imm12;
    output [6:0] opcode, funct7;
    output reg_write_en;
    output reg [2:0] wb_sel;
    output mem_req_write, mem_req_type;
    input [31:0] inst;
    wire [2:0] funct3;

    assign funct7 = inst[31:25];
    assign imm12 = inst[31:20];
    assign rs2 = inst[24:20];
    assign rs1 = inst[19:15];
    assign funct3 = inst[14:12];
    assign rd  = inst[11:7];
    assign opcode = inst[6:0];

    assign reg_write_en = (opcode == `OPCODE_OP ||
                           opcode == `OPCODE_OP_IMM ||
                           opcode == `OPCODE_LUI ||
                           opcode == `OPCODE_LOAD ||
                           opcode == `OPCODE_JAL ||
                           opcode == `OPCODE_JALR ||
                           opcode == `OPCODE_SYS);

    assign memory_request = (opcode == `OPCODE_LOAD ||
                             opcode == `OPCODE_STORE);

	assign memory_request_type = (opcode == `OPCODE_STORE) ?
	                             `MEM_REQ_WRITE : `MEM_REQ_READ;

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
