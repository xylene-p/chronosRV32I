// Chronos - A RISC-V Processor
// Hybrid Branch Prediction in a Pipelined Processor
// Author: Katherine Perez

module ChronosCore(
  // outputs
  rs1, rs2, rd,
  // inputs
  en, clk, rst, nop, pc_sel);

  wire [31:0] data;
  input         en, clk, rst, pc_sel;
  input [31:0]  nop;

  wire [31:0]  fetch_addr, fetch_addr_next, request_data;
  wire         fetch_req, fetch_data_valid;
  wire         kill;

  output wire [4:0] rs1, rs2, rd;
  wire [4:0] rw_addr;
  wire [31:0] rw_data, rd1_data, rd2_data;
  wire rw_en;


  /* Instruction Fetch Stage */

  // PC Register
  register PCReg(
    .q(fetch_addr),
    .valid(fetch_req),
    .d(fetch_addr_next),
    .en(en),
    .clk(clk),
    .rst(rst));

  // Instruction Memory
  inst_mem InstructionMemory(
    .request_data(request_data),
    .fetch_data_valid(fetch_data_valid),
    .fetch_addr(fetch_addr),
    .fetch_req(fetch_req),
    .clk(clk),
    .rst(rst));

  /* IF/ID Stage */

  // PC + 4 Register
  add_const #(4) PCNext(
    .out(fetch_addr_next),
    .in(fetch_addr));

  // PC Mux
  mux2to1 PCMux(
    .out(data),
    .in1(request_data),
    .in2(nop),
    .sel(pc_sel));

  /* ID Stage */

  // Instruction Decoder
  decode Decoder(
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),
    .reg_write_en(reg_write_en),
    .wb_sel(wb_sel),
    .inst(data));

  // General-Purpose Register File
  regfile RegisterFile(
    .rd1(rd1_data),
    .rd2(rd2_data),
    .rs1(rs1),
    .rs2(rs2),
    .rw_dest(rw_addr),
    .rw_data(rw_data),
    .rw_en(rw_en),
    .clk(clk),
    .rst(rst));

  // Decoder


endmodule
