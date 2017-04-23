`timescale 1ns/1ns

`include "defines.vh"

module Core_tb();

  reg clk = 0, rst;
  reg [31:0] nop;
  reg en;
  wire [4:0] rs1, rs2, rd;
  wire [11:0] imm12;

  integer i = 0;

  ChronosCore core(
    .dcd_rs1(rs1),
    .dcd_rs2(rs2),
    .dcd_rd(rd),
    .dcd_imm12(imm12),
    .clk(clk),
    .rst(rst),
    .nop(nop),
    .en(en));

  parameter half_cycle = 5;
  localparam cycle = 2 * half_cycle;
  localparam timeout = 100;

  always #(half_cycle) clk = ~clk;

  initial begin
    $dumpfile("core.vcd");
    $dumpvars();
    nop <= `INST_NOP;
    en <= 1;

    rst <= 0;
    #(cycle);
    #(cycle);
    rst <= 1;

    while (i < timeout) begin
    //   $display("Cycle %5d: pc=[%08x] inst_fetch=[%08x] rs1=[%x] rs2=[%x] rd=[%x]",
	// 			   i, core.PCReg.q, core.Decoder.inst, core.rs1, core.rs2, core.rd);
        $display("Cycle %5d: [pc=%x, inst=%x] [op=%x, funct3=%x, funct7=%x, rs1=%x, rs2=%x, rd=%x, imm=%d]",
                 i, core.PCReg.q, core.InstructionMemory.request_data, core.Decoder.opcode,
                 core.Decoder.funct3, core.Decoder.funct7, core.Decoder.rs1, core.Decoder.rs2,
                 core.Decoder.rd, core.Decoder.imm12);
      i = i + 1;
      #(cycle);
    end

    if (i == timeout) begin
			$display("*** TIMEOUT ***");
			$finish();
	end

    $finish();
  end

endmodule
