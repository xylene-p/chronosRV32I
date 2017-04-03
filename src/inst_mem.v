// Chronos instruction memory

module chronos_inst_mem(
    // outputs
    req_data
    // inputs
    req_addr, req_val, clk
    );

    reg [31:0] inst_mem [0:5]

    initial begin
        $readmemh("mem.hex", memory);
    end

endmodule
