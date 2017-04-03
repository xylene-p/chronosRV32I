// Chronos ALU

`include "defines.vh"

module alu (
    // outputs
    alu_out,
    // inputs
    op1, op2,
    alu_func
    );

    output reg [31:0] alu_out;
    input      [31:0] op1, op2;
    input      [3:0]  alu_func;

    always @ (*) begin
        case (alu_func)
            `ALU_ADD:   alu_out = op1 + op2;
            `ALU_SUB:   alu_out = op1 - op2;

            // Logic Functions
            `ALU_AND:   alu_out = op1 & op2;
            `ALU_OR:    alu_out = op1 | op2;
        endcase
    end // always @ (*) begin

endmodule
