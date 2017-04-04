// Chronos - A RISC-V Processor
// Instruction Fetch Stage
// Author: Katherine Perez

module IFStage(
  // outputs
  request_data, fetch_data_valid,
  // inputs
  en, clk, rst
  );

  output [31:0] request_data;
  output        fetch_data_valid;
  input         en, clk, rst;

  wire [31:0]  fetch_addr, fetch_addr_next;
  wire         fetch_req;

  register PCReg(
    .q(fetch_addr),
    .valid(fetch_req),
    .d(fetch_addr_next),
    .en(en),
    .clk(clk),
    .rst(rst)
    );
  add_const #(4) PCNext(
    .out(fetch_addr_next),
    .in(fetch_addr)
    );
  inst_mem InstructionMemory(
    .request_data(request_data),
    .fetch_data_valid(fetch_data_valid),
    .fetch_addr(fetch_addr),
    .fetch_req(fetch_req),
    .clk(clk),
    .rst(rst)
    );

endmodule
