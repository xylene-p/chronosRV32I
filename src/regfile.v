// Register File
// Author: Katherine Perez

/**
 * rd* (output) - register data
 * rs* (input)  - register source address
 * rw_dest      - register write address
 * rw_data      - register write data
 * rw_en        - register_write enable
 * clk          - clock
 * rst          - reset
 */

module regfile(
    rd2, rd1,
    rs1, rs2, rw_dest, rw_data, rw_en,
    clk, rst);

    parameter num_regs = 32;
    reg [31:0] registers[num_regs-1:0];

    output [31:0] rd1, rd2;
    input  [4:0]  rs1, rs2, rw_dest;
    input  [31:0] rw_data;
    input         rw_en, clk, rst;

    always @(posedge clk) begin
        // write to register
        if (rw_en) begin
            registers[rw_dest] <= rw_data;
        end
    end

    assign rd1 = rs1 == 0 ? 32'b0 : registers[rs1];
    assign rd2 = rs2 == 0 ? 32'b0 : registers[rs2];

endmodule
