// Chronos - A RISC-V Processor
// Hybrid Branch Prediction in a Pipelined Processor
// Author: Katherine Perez

module ChronosCore(
  // outputs
  dcd_rs1, dcd_rs2, dcd_rd, dcd_imm12,
  // inputs
  clk, rst, nop);

  wire [31:0] data;
  input         clk, rst;
  input [31:0]  nop;

  wire [31:0]  fetch_addr, fetch_addr_next, request_data;
  wire         fetch_req, fetch_data_valid;
  wire         kill;

  output wire [4:0] dcd_rs1, dcd_rs2, dcd_rd;
  output wire [11:0] dcd_imm12;
  wire [6:0] dcd_funct7, dcd_opcode;
  wire [4:0] rw_addr;
  wire [31:0] rw_data, rs1_data, rs2_data;
  wire [2:0] wb_sel;
  wire en, en2, rw_en;
  wire pc_sel;

  // Decode - Internal Wires
  wire [31:0] op1, op2;
  wire [4:0] alu_sel;


  /* Instruction Fetch Stage */

  // PC Register
  register_pc PCReg(
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

  // PC + 4 Register
  add_const #(4) PCNext(
    .out(fetch_addr_next),
    .in(fetch_addr));

  // PC Mux
  mux_2_1 PCMux(
    .out(data),
    .in1(request_data),
    .in2(nop),
    .sel(pc_sel));

  /* IF/ID Stage */



  /* ID Stage */

  // Instruction Decoder
  decode_control Decoder(
    .rs1(dcd_rs1),
    .rs2(dcd_rs2),
    .rd(dcd_rd),
    .imm12(dcd_imm12),
    .opcode(dcd_opcode),
    .funct7(dcd_funct7),
    .reg_write_en(reg_write_en),
    .wb_sel(wb_sel),
    .inst(data));

  // Hazard Detection Unit

  hazard_detect HDU(
    .PC_write(en),
    .IFID_write(en2), // TODO: wire this to IF/ID register
    .Mux_select(pc_sel),
    .inst_type(dcd_opcode),
    .IFID_Reg_Rs1(dcd_rs1),
    .IFID_Reg_Rs2(dcd_rs2),
    .IFID_Reg_Rd(dcd_rd),
    .IDEX_MemRead(mem_read_en),
    .IDEX_Reg_Rd(idex_rd));

  // General-Purpose Register File
  register_file RegisterFile(
    .rd1(rs1_data),
    .rd2(rs2_data),
    .rs1(dcd_rs1),
    .rs2(dcd_rs2),
    .rw_dest(rw_addr),
    .rw_data(rw_data),
    .rw_en(rw_en),
    .clk(clk),
    .rst(rst));

  decode_alu ALUDecoder(
    .op1(alu_op1),
    .op2(alu_op2),
    .alu_sel(alu_sel),
    .inst(inst),
    .rs1(rs1_data),
    .rs2(rs2_data));

    /* ID/EX Stage */

    /* EX Stage */





    /* EX/MEM Stage */

    /* MEM Stage */




    /* MEM/WB Stage*/

    /* WB Stage */

endmodule
