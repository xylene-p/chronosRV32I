// Chronos Test Harness
// Author: Katherine Perez

module chronosTestHarness(
    output testrig_tohost;
    input testrig_fromhost, clk, rst);

    wire [31:0] imem_req_addr, imem_resp_data;
    wire imem_req_val;

    wire [31:0] dmem_req_addr, dmem_req_wdata, dmem_resp_data;
    wire dmem_req_rw, dmem_req_val;

    // Chronos Core CPU
    chronosCore CPU(.testrig_tohost(testrig_tohost),
                    .imem_req_addr(imem_req_addr),
                    .imem_req_val(imem_req_val),
                    .imem_resp_data(imem_resp_data),
                    .dmem_req_rw(dmem_req_rw),
                    .dmem_req_addr(dmem_req_addr),
                    .dmem_req_wdata(dmem_req_wdata),
                    .dmem_req_val(dmem_req_val),
                    .clk(clk),
                    .rst(rst),
                    .testrig_fromhost(testrig_fromhost));

    // Instruction memory request:
    // addr => fetch address
    // req_val => request value, 1 to begin request
    inst_mem InstructionMemory(.request_data(imem_resp_data),
                               .fetch_addr(imem_req_addr),
                               .fetch_req(imem_req_val),
                               .clk(clk));

    // Data memory request:
    // req_rw => 0 for load, 1 for store
    // addr => memory address
    // wdata => write data (if applicable)
    // req_val => 1 to begin request
    data_mem DataMemory(.load_data(dmem_resp_data),
                        .cmd(dmem_req_rw),
                        .addr(dmem_req_addr),
                        .write_data(dmem_req_wdata),
                        .enable(dmem_req_val));

endmodule
