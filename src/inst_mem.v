// Chronos instruction memory

module chronos_inst_mem(
    // outputs
    req_data
    // inputs
    mem_addr, clk, rst
    );

    output [31:0] req_data;
    
    reg [31:0] memory [0:5];

    always @(*) begin
        if (rst == 1'b0)
            begin
                $readmemh("mem.hex", memory);
            end
        else
            req_data <= memory[mem_addr];
    end

endmodule
