// Chronos Regfile

module regfile(
    // outputs
    data_out,
    // inputs
    addr, clk, rst
    );

    output [31:0] data_out;

    input [31:0] addr;
    input clk, rst;

    parameter REG_DEPTH = 8;

endmodule
