// Chronos Branch Target and Branch Condition Generator
// Author: Katherine Perez

`include "defines.vh"

module branch_gen(
    // outputs
    branch_target, branch_taken,
    // inputs
    inst, pc, alu_out);

    output [31:0] branch_target;
    output reg branch_taken;
    input [31:0] inst, pc, alu_out;

    wire [6:0] opcode = inst[6:0];
    wire [2:0] funct3 = inst[14:12];
    wire [11:0] branch_split_imm = {inst[31], inst[7], inst[30:25], inst[11:8]};
    wire [31:0] branch_imm = { {20{branch_split_imm[11]}}, branch_split_imm };

    assign branch_target = pc + ($signed(branch_imm) << 1);

    always @(*) begin
        if (opcode == `OPCODE_BRANCH) begin
            case (funct3)
                `F3_BEQ:
                    branch_taken <= (alu_out == 0);
                `F3_BNE:
                    branch_taken <= (alu_out != 0);
                `F3_BLT:
                    branch_taken <= (alu_out == 1);
                `F3_BGE:
                    branch_taken <= (alu_out != 1);
                `F3_BLTU:
                    branch_taken <= (alu_out == 1);
                `F3_BGEU:
                    branch_taken <= (alu_out != 1);
                default:
                    branch_taken <= 0;
            endcase
        end
    end

endmodule
