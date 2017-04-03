// Chronos Core

module chronos_core(
    // outputs
    inst
    // inputs
    addr, clk, rst
    );

    output [31:0] inst;
    input [31:0]  addr;
    input clk, rst;

    /* Instruction Fetch */
    core_reg PCReg(pc_next, pc);

    assign addr = pc_next;

    inst_mem InstructionMemory(inst, pc, clk, rst);

module core_reg(
    data_out,
    data_in, clk, rst
    );

    output [31:0] data_out;
    input [31:0] data_in;
    input clk, rst;

    always @ (posedge clk) begin
        if (rst == 1'b0)
            data_out <= 32'b0;
        else
            data_out <= data_in;
    end

endmodule

endmodule // chronos
