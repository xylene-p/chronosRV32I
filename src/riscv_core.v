/*
 *  RISC-V ISA Simulator
 *
 *  Code derived from https://github.com/CMU-18447/verilog_starter_code
 */


/*
 *  RISC-V Core Module
 *
 *  inst_addr       (output) - Address of instruction to load
 *  inst            (input)  - Instruction from memory
 *
 */
module riscv_core(
    // Outputs
    output [29:0] inst_addr;

    // Inputs
    input clk;
    input [31:0] inst;

    // Internal signals
    // pc - program counter
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

/*
 *  register: A register which may be reset to an arbitrary value
 *
 *  q      (output) - Current value of register
 *  d      (input)  - Next value of register
 *  clk    (input)  - Clock (positive edge-sensitive)
 *  enable (input)  - Load new value?
 *  reset  (input)  - System reset
 *
 */

module register(q, d, clk, enable, rst_b);

    parameter
             width = 32,
             reset_value = 0;

    output [(width-1):0]  q;
    reg    [(width-1):0]  q;
    input  [(width-1):0]  d;
    input                 clk, enable, rst_b;

    always @(posedge clk or negedge rst_b)
        if (~rst_b)
            q <= reset_value;
        else if (enable)
            q <= d;

endmodule // register

/*
 *  adder
 *
 *  out (output) - adder result
 *  in1 (input)  - Operand1
 *  in2 (input)  - Operand2
 *  sub (input)  - Subtract?
 *
 */
module adder(out, in1, in2, sub);
    output [31:0]   out;
    input [31:0]    in1, in2;
    input           sub;

    assign          out = sub ?(in1 - in2):(in1 + in2);

endmodule // adder
