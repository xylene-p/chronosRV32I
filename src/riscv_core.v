/*
 *  RISC-V ISA Simulator
 *
 *
 */


/*
 *  RISC-V Core Module
 *
 *  inst_addr       (output) - Address of instruction to load
 *  inst            (input) - Instruction from memory
 *
 */
module riscv_core(
    // Outputs
    output [29:0] inst_addr;

    // Inputs
    input clk;
    input [31:0] inst;

    // Internal signals
    wire [31:0] pc;

    );

    assign inst_addr = pc[31:2];
endmodule // riscv_core

/*
 *  RISC-V ALU Module
 *
 */
module riscv_alu(
    output [31:0]   out;
    input [31:0]    in1, in2;
    input           ctrl;
    );

    adder Adder(out, in1, in2, ctrl);
endmodule // riscv_alu

module adder(out, in1, in2, sub);
    output [31:0]   out;
    input [31:0]    in1, in2;
    input           sub;

    assign          out = sub ? (in1 - in2) : (in1 + in2);

endmodule // adder
