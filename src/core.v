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
    else begin
        inst <= imem_resp_data;

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
endmodule
