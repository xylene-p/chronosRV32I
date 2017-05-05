// Chronos - A RISC-V Processor
// Hybrid Branch Prediction in a Pipelined Processor
// Author: Katherine Perez

`include "defines.vh"

module chronosCore(
  // outputs
  output testrig_tohost,
  output [31:0] imem_req_addr,
  output imem_req_val,
  output dmem_req_rw,
  output [31:0] dmem_req_addr,
  output [31:0] dmem_req_wdata,
  output dmem_req_val,
  // inputs
  input testrig_fromhost,
  input [31:0] imem_resp_data,
  input [31:0] dmem_resp_data,
  input clk,
  input rst);

  // instruction fetch registers
  reg [2:0] pc_sel;
  reg [31:0] pc, pc_next, if_pc, curr_pc4, branch_target,
             branch_predicted_target;
  reg [31:0] inst;
  wire [31:0] corr_pc4;

  wire kill_IF;

  //======= Instruction Fetch =======//
  initial begin
    pc_sel = `PCMUX_CURR_PC4;
  end

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
  assign imem_req_val = rst;

  // PC Reg
  always @(posedge clk) begin
    if (rst == 0) begin
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
    if (rst == 0) begin
        curr_pc4 <= 0;
        inst <= 0;
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

  // Decode signals
  wire [4:0] dcd_rs1, dcd_rs2, dcd_rd;
  wire [31:0] dcd_rs1_data, dcd_rs2_data;
  wire [11:0] dcd_imm12;
  wire [6:0] dcd_opcode, dcd_funct7;
  wire dcd_reg_write_en;
  wire [2:0] dcd_wb_sel;
  wire dcd_mem_req_write, dcd_mem_req_type;

  // Regfile RS1, RS2
  wire [31:0] rf_rs1_data, rf_rs2_data;

  // ALU signals
  wire [31:0] alu_out, alu_op1, alu_op2;
  wire [3:0] alu_sel;

  // Writeback signals
  reg [31:0] wb_write_data;

  decode_control Decoder(.rs1(dcd_rs1),
                         .rs2(dcd_rs2),
                         .rd(dcd_rd),
                         .imm12(dcd_imm12),
                         .reg_write_en(dcd_reg_write_en),
                         .wb_sel(dcd_wb_sel),
                         .opcode(dcd_opcode),
                         .funct7(dcd_funct7),
                         .mem_req_write(dcd_mem_req_write),
                         .mem_req_type(dcd_mem_req_type),
                         .inst(inst));

  register_file RegFile(.rs1_data(rf_rs1_data),
                        .rs2_data(rf_rs2_data),
                        .rs_1(dcd_rs1),
                        .rs_2(dcd_rs2),
                        .register_write(dcd_rd),
                        .write_data(wb_write_data),
                        .register_write_enable(dcd_reg_write_en));

  decode_alu ALUDecoder(.op1(alu_op1),
                        .op2(alu_op2),
                        .alu_sel(alu_sel),
                        .inst(inst),
                        .rs1(rf_rs1_data),
                        .rs2(rf_rs2_data));

  alu ALU(.alu_out(alu_out),
          .op1(alu_op1),
          .op2(alu_op2),
          .alu_sel(alu_sel));

  // Writeback Mux
  always @(*) begin
    case (dcd_wb_sel)
        `WB_ALU:
            wb_write_data = alu_out;
        `WB_MEM:
            wb_write_data = dmem_resp_data;
        `WB_PC4:
            wb_write_data = corr_pc4;
        // TODO: is default needed?
    endcase
  end


endmodule
