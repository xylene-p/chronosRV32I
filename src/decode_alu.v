// ALU Decoder
// Author: Katherine Perez

`include "defines.vh"

// Decodes the instruction for proper ALU function select
// Selects the correct operands for the ALU
// op*     (output) ALU operand
// alu_sel (output) ALU select
// inst    (input)  instruction
// rs*     (input)  regfile register value
module decode_alu(
    // outputs
    op1, op2, alu_sel,
    // inputs
    inst, rs1, rs2);

    output reg [31:0] op1, op2;
    output reg [4:0] alu_sel;
    input [31:0] inst, rs1, rs2;

    // instruction slots
    wire [6:0] opcode = inst[6:0];
    wire [2:0] funct3 = inst[14:12];
    wire [4:0] shamt = inst[24:20];
    wire [6:0] funct7 = inst[31:25];
    wire [11:0] imm12 = inst[31:20];
    wire [19:0] lui_imm = inst[31:12];
    wire [31:0] sign_ext_imm = imm12[11] ? {20'hFFFFF, imm12} : {20'b0, imm12};

    wire [6:0] imm12hi = inst[31:25];
    wire [4:0] imm12lo = inst[11:7];
    wire [11:0] split_imm12 = {imm12hi, imm12lo};

    always @(*) begin
        // Operand 1 Assignment
        op1 = (opcode == `OPCODE_LUI) ? {12'b0, lui_imm} : rs1;

        // Operand 2 Assignment
        case (opcode)
            // R-Type Instruction:
            `OPCODE_OP:
                // add or subtract
                op2 = (funct3 == `F3_ADD && funct7[5]) ? -rs2 : rs2;
            // I-Type Instruction:
            `OPCODE_OP_IMM:
                case (funct3)
                    // sign-extended immediate
                    `F3_ADD, `F3_SLT, `F3_SLTU, `F3_XOR, `F3_OR, `F3_AND:
                        op2 = s_ext_imm;
                    // shift
                    `F3_SLL, `F3_SR:
                        op2 = shamt;
                    default:
                        op2 = 0;
                endcase
            // Store Instruction
            `OPCODE_STORE:
                op2 = split_imm12;
            // Load Instruction
            `OPCODE_LOAD:
                op2 = imm12;

            default:
                op2 = rs2;
        endcase

        // ALU function select
        case (opcode)
            `OPCODE_OP, `OPCODE_OP_IMM:
                case (funct3)
                    `F3_ADD:  alu_sel = `ALU_ADD;
                    `F3_SLL:  alu_sel = `ALU_SLL;
                    `F3_SLT:  alu_sel = `ALU_SLT;
                    `F3_SLTU: alu_sel = `ALU_SLTU;
                    `F3_XOR:  alu_sel = `ALU_XOR;
                    `F3_SR:   alu_sel = inst[30] ? `ALU_SRA : `ALU_SRL;
                    `F3_OR:   alu_sel = `ALU_OR;
                    `F3_AND:  alu_sel = `ALU_AND;
                    default:  alu_sel = `ALU_NONE;
                endcase

            `OPCODE_LOAD, `OPCODE_STORE:
                alu_sel = `ALU_ADD;

            `OPCODE_LUI:
                alu_sel = `ALU_LUI;

            `OPCODE_BRANCH:
                case (funct3)
                    `F3_BEQ, `F3_BNE:   alu_sel = `ALU_XOR;
                    `F3_BLT, `F3_BGE:   alu_sel = `ALU_SLT;
                    `F3_BLTU, `F3_BGEU: alu_sel = `ALU_SLTU;
                    default: alu_sel = `ALU_NONE;
                endcase

            default:
                alu_sel = `ALU_NONE;

        endcase
    end

endmodule
