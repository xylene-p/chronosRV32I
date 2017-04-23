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

  output wire [4:0] dcd_rs1, dcd_rs2, dcd_rd;
  output wire [11:0] dcd_imm12;
  wire [6:0] dcd_funct7, dcd_opcode;
  wire [4:0] rw_addr;
  wire [31:0] rw_data, rs1_data, rs2_data;
  wire [2:0] wb_sel;
  wire en, rw_en;

  // Decode Wires
  wire [31:0] alu_op1, alu_op2;
  wire [4:0] alu_sel;

  // Hazard Detect Unit Wires
  wire [2:0] pc_sel;
  wire IFID_write, mux_select, kill_IF, kill_DEC;
  wire [4:0] regIDEX_rd;

  // Branch Predictor Wires
  wire [31:0] branch_predicted_target;
  wire branch_prediction;

  // IF/ID Output Wires
  wire [31:0] pc4_IFID_out, inst_IFID_out;
  wire pred_IFID_out;

  // Branch Target Generator Wires
  wire [31:0] branch_target;

  // ID/EX Output Wires
  wire [31:0] inst_IDEX_out, pc_IDEX_out, alu_out;


  /* Instruction Fetch Stage */

  mux_4_1 PCMux(
    .pc_next(fetch_addr),
    .pc_sel(pc_sel),
    .curr_pc4(fetch_addr_next),
    .branch(branch_target),
    .corr_pc4(inst_IFID_out),
    .predicted_target(branch_predicted_target));

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

  // Instruction Fetch Kill
  mux_2_1 IFKill(
    .out(data),
    .in1(request_data),
    .in2(nop),
    .sel(kill_IF));

  branch_predictor BranchPredictor(
    .pred_target(branch_predicted_target),
    .prediction(branch_prediction),
    .correct_target(fetch_addr),
    .correct_pc4(pc4_IFID_out),
    .curr_pc4(fetch_addr_next),
    .clk(clk),
    .rst(rst));

  /* IF/ID Stage */

  register_IFID IFIDRegister(
     .pc4_out(pc4_IFID_out),
     .instruction_out(inst_IFID_out),
     .prediction_out(pred_IFID_out),
     .pc4_in(fetch_addr_next),
     .instruction_in(request_data),
     .prediction_in(branch_prediction),
     .clk(clk),
     .rst(rst),
     .en(IFID_write));

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
    .pc_sel(pc_sel),
    .IFID_write(IFID_write),
    .mux_select(en),
    .kill_IF(kill_IF),
    .kill_DEC(kill_DEC),
    .opcode(dcd_opcode),
    .regIFID_rs1(dcd_rs1),
    .regIFID_rs2(dcd_rs2),
    .regIFID_rd(dcd_rd),
    .regIDEX_rd(regIDEX_rd),
    .memReadIDEX(idex_rd));

  // General-Purpose Register Fileen2
  register_file RegisterFile(
    .read_data_1(rs1_data),
    .read_data_2(rs2_data),
    .rs_1(dcd_rs1),
    .rs_2(dcd_rs2),
    .register_write(rw_addr),
    .write_data(rw_data),
    .register_write_enable(rw_en));

  decode_alu ALUDecoder(
    .op1(alu_op1),
    .op2(alu_op2),
    .alu_sel(alu_sel),
    .inst(inst_IFID_out),
    .rs1(rs1_data),
    .rs2(rs2_data));

  /* ID/EX Stage */

  register_IDEX IDEXRegister(
    .pc4_out(),
    .operand1_out(),
    .operand2_out(),
    .instruction_rd_out(),
    .prediction_out(),
    .register_write_enable_out(),
    .mem_request_write_out(),
    .mem_request_type_out(),
    .alu_sel_out(),
    .wb_sel_out(),
    .IDEXRegRead_out(),
    .IDEXMemRead(),
    .clk(clk),
    .rst(rst),
    .en(),
    .pc4_in(),
    .operand1_in(),
    .operand2_in(),
    .instruction_rd_in(),
    .prediction_in(),
    .register_write_enable_in(),
    .mem_request_write_in(),
    .mem_request_type_in(),
    .alu_sel_in(),
    .wb_sel_in());

  /* EX Stage */

  // TODO: ALU MODULE HERE

  branch_gen BranchGenerator(
    .branch_target(branch_predicted_target),
    .branch_taken(branch_taken),
    .inst(inst_IDEX_out),
    .pc(pc_IDEX_out),
    .alu_out(alu_out));

  /* EX/MEM Stage */

  /* MEM Stage */




  /* MEM/WB Stage*/

  /* WB Stage */

endmodule
