// Chronos - A RISC-V Processor
// Hybrid Branch Prediction in a Pipelined Processor
// Author: Katherine Perez

`include "defines.vh"

module chronosCore(
  // outputs
  output testrig_tohost,
  output [31:0] imem_req_addr,
  output imem_req_val,
  // inputs
<<<<<<< HEAD:src/core.v
  input testrig_fromhost,
  input [31:0] imem_resp_data,
  input clk, rst);

  // instruction fetch registers
  reg [31:0] pc, pc_next, if_pc, corr_pc4, curr_pc4, branch_target,
             branch_predicted_target;
  reg [31:0] inst;

  //======= Instruction Fetch =======//

  // PCMux
  always @(*) begin
    case (pc_sel)
        `PCMUX_CURR_PC4:
            if_pc = curr_pc4;
        `PCMUX_BRANCH:
            if_pc = branch_target;
        `PCMUX_CORR_PC4:
            if_pc = corr_pc4;
        `PCMUX_PRED_TGT:
            if_pc = branch_predicted_target;
    endcase
  end

  assign imem_req_addr = if_pc;
  assign imem_req_val = !reset;

  // PC Reg
  always @(posedge clk) begin
    if (reset == 0) begin
        pc <= 0;
    end
    else begin
        pc <= if_pc;
    end
  end

  // IF Kill Mux
  always @(*) begin
    if (kill_IF) begin
        inst <= `INST_NOP;
    end
    else begin
        inst <= imem_resp_data;
    end
  end

  //======= IF/EX Registers =======//

  always @(posedge clk) begin
    if (reset == 0) begin
        curr_pc4 <= 0;
        inst <= `INST_NOP;
        pc <= 0;
    end
    else begin
        curr_pc4 <= pc + 4;
        inst <= imem_resp_data;
        pc <= pc;
    end
  end

  assign corr_pc4 = curr_pc4;

  //======= Instruction Execute =======//

  wire [4:0] rs1, rs2;
  wire [31:0] rs1_data, rs2_data;

  decode_control Decoder();

  register_file RegFile(.read_data1(read),
                        .read_data2(),
                        .rs_1());

  alu_decode ALUDecoder();

  alu ALU();

  // write back mux
=======
  clk, rst, nop, en);

  wire [31:0] data;
  input         clk, rst;
  input [31:0]  nop;

  wire [31:0]  fetch_addr, fetch_addr_next, request_data;
  wire         fetch_req, fetch_data_valid;

  output wire [4:0] dcd_rs1, dcd_rs2, dcd_rd;
  output wire [11:0] dcd_imm12;
  wire [6:0] dcd_funct7, dcd_opcode;
  wire dcd_mem_req_type, dcd_mem_req_write;
  wire [4:0] rw_addr;
  wire [31:0] rw_data, rs1_data, rs2_data;
  wire [2:0] wb_sel;
  input en;
  wire rw_en;

  // Decode Wires
  wire [31:0] alu_op1, alu_op2;
  wire [3:0] alu_sel;

  // Hazard Detect Unit Wires
  wire [2:0] pc_sel;
  wire IFID_write, mux_select, kill_IF, kill_DEC;
  wire [4:0] regIDEX_rd;

  // Branch Predictor Wires
  wire [31:0] branch_predicted_target;
  wire branch_prediction;

  // IF/ID Output Wires
  wire [31:0] pc4_IFID_out, pc_IFID_out, inst_IFID_out;
  wire pred_IFID_out;

  // Branch Target Generator Wires
  wire [31:0] branch_target;

  // ID/EX Output Wires
  wire [31:0] pc4_IDEX_out, pc_IDEX_out, inst_IDEX_out, op1_IDEX_out, op2_IDEX_out;
  wire [4:0] inst_rd_IDEX_out, reg_read_IDEX_out, rs2_IDEX_out;
  wire prediction_IDEX_out, reg_write_en_IDEX_out,
       mem_read_IDEX_out, mem_req_write_IDEX_out,
       mem_req_type_IDEX_out;
  wire [3:0] alu_sel_IDEX_out;
  wire [2:0] wb_sel_IDEX_out;

  // ALU wires
  wire [31:0] alu_out;

  // EX/MEM Output Wires
  wire [31:0] alu_EXMEM_out;
  wire [4:0] inst_rd_EXMEM_out, rs2_EXMEM_out;
  wire reg_write_en_EXMEM_out;
  wire mem_req_write_EXMEM_out, mem_req_type_EXMEM_out;
  wire [2:0] wb_sel_EXMEM_out;

  /* Instruction Fetch Stage */


  mux_4_1 PCMux(
    .pc_next(fetch_addr),
    .pc_sel(pc_sel),
    .curr_pc4(fetch_addr_next),
    .branch(branch_target),
    .predicted_target(branch_predicted_target));

  // PC Register
  register_pc PCReg(
    .q(fetch_addr),
    .d(fetch_addr_next),
    .en(en),
    .clk(clk),
    .rst(rst));

  // Instruction Memory
  inst_mem InstructionMemory(
    .request_data(request_data),
    .address(fetch_addr),
    .clk(clk),
    .rst(rst),
    .wb_en(), 
    .wb_address(), 
    .wb_data();

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
    .current_pc4(fetch_addr_next),
    .clk(clk),
    .rst(rst));

  /* IF/ID Stage */

  register_IFID IFIDRegister(
    .pc4_out(pc4_IFID_out),
    .pc_out(pc_IFID_out),
    .instruction_out(inst_IFID_out),
    .prediction_out(pred_IFID_out),
    .pc4_in(fetch_addr_next),
    .pc_in(fetch_addr),
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
    .mem_req_write(dcd_mem_req_write),
    .mem_req_type(dcd_mem_req_type),
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

  mux_2_1 IDKill(
    .out(),
    .in1(),
    .in2(nop),
    .sel(kill_DEC));

  /* ID/EX Stage */

  register_IDEX IDEXRegister(
    .pc4_out(pc4_IDEX_out),
    .pc_out(pc_IDEX_out),
    .inst_out(inst_IDEX_out),
    .operand1_out(op1_IDEX_out),
    .operand2_out(op2_IDEX_out),
    .instruction_rd_out(inst_rd_IDEX_out),
    .prediction_out(prediction_IDEX_out),
    .register_write_enable_out(reg_write_en_IDEX_out),
    .mem_request_write_out(mem_req_write_IDEX_out),
    .mem_request_type_out(mem_req_type_IDEX_out),
    .alu_sel_out(alu_sel_IDEX_out),
    .wb_sel_out(wb_sel_IDEX_out),
    .IDEXRegRead_out(reg_read_IDEX_out),
    .IDEXMemRead(mem_read_IDEX_out),
    .rs2_out(rs2_IDEX_out),
    .clk(clk),
    .rst(rst),
    .en(en),
    .pc4_in(pc4_IFID_out),
    .pc_in(pc_IFID_out),
    .operand1_in(alu_op1),
    .operand2_in(alu_op2),
    .instruction_rd_in(dcd_rd),
    .rs2_in(dcd_rs2),
    .prediction_in(branch_prediction),
    .register_write_enable_in(reg_write_en),
    .mem_request_write_in(dcd_mem_req_type),
    .mem_request_type_in(dcd_mem_req_write),
    .alu_sel_in(alu_sel),
    .wb_sel_in(wb_sel));

  /* EX Stage */

  alu ALU(
    .alu_out(alu_out),
    .op1(op1_IDEX_out),
    .op2(op2_IDEX_out),
    .alu_sel(alu_sel_IDEX_out));

  branch_gen BranchGenerator(
    .branch_target(branch_predicted_target),
    .branch_taken(branch_taken),
    .inst(inst_IDEX_out),
    .pc(pc_IDEX_out),
    .alu_out(alu_out));

  /* EX/MEM Stage */

  register_EXMEM MEMEXRegister(
    .alu_out(alu_EXMEM_out),
    .rs2_out(rs2_EXMEM_out),
    .instruction_rd_out(inst_rd_EXMEM_out),
    .register_write_enable_out(reg_wr_en_EXMEM_out),
    .mem_request_write_out(mem_req_write_EXMEM_out),
    .mem_request_type_out(mem_req_type_EXMEM_out),
    .wb_sel_out(wb_sel_EXMEM_out),
    .alu_out_in(alu_out),
    .rs2_in(rs2_IDEX_out),
    .instruction_rd_in(),
    .clk(clk),
    .en(en),
    .rst(rst),
    .register_write_enable_in(),
    .mem_request_write_in(),
    .mem_request_type_in(),
    .wb_sel_in());

  /* MEM Stage */

  data_memory DataMemory(
    .output_data(), // out to WB mux
    .memory_addr(),
    .write_data(),
    .write_mask(),
    .instruction(),
    .data(), // in from RS2
    .addr()); // in from ALU out

  simulated_mem SimulatedMemory(
    .load_data(),
    .valid(),
    .write_data(),
    .cmd(),
    .enable(),
    .mask(),
    .addr(),
    .clk(),
    .reset());

  /* MEM/WB Stage*/

  register_MEMWB MEMWBRegister(
    .wb_data_out(),
    .instruction_rd_out(),
    .register_write_enable_out(),
    .wb_data_in(),
    .instruction_rd_in(),
    .clk(clk),
    .rst(rst),
    .en(en),
    .register_write_enable_in());

  /* WB Stage */

  writeback WritebackStage(
    .output_data(),
    .out_data_mem(),
    .out_pc4(),
    .out_alu(),
    .wb_sel());


>>>>>>> 4002fce60f4e14ebde5ff3e070288a770b7d939d:archive/core.v
endmodule
