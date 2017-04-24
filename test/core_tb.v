`timescale 1ns/1ns

`include "defines.vh"

module Core_tb();

  wire testrig_tohost;
  reg clk = 0, rst;
  reg [31:0] nop;
  reg testrig_fromhost;

  integer i = 0;

  chronosTestHarness core(
      testrig_tohost,
      testrig_fromhost,
      clk, rst);

  parameter half_cycle = 5;
  localparam cycle = 2 * half_cycle;
  localparam timeout = 100;

  always #(half_cycle) clk = ~clk;

  initial begin
    $dumpfile("core.vcd");
    $dumpvars();
    nop <= `INST_NOP;
    testrig_fromhost <= 1;

    rst <= 0;
    #(cycle);
    #(cycle);
    rst <= 1;

    while (i < timeout) begin
    //   $display("Cycle %5d: pc=[%08x] inst_fetch=[%08x] rs1=[%x] rs2=[%x] rd=[%x]",
	// 			   i, core.PCReg.q, core.Decoder.inst, core.rs1, core.rs2, core.rd);
        $display("Cycle %5d: [pc=%x, inst=%x] [op=%x, funct3=%x, funct7=%x, rs1=%x, rs2=%x, rd=%x, imm=%d]",
                 i, core.CPU.if_pc, core.CPU.inst, core.CPU.dcd_opcode, core.CPU.Decoder.funct3, core.CPU.Decoder.funct7,
                 core.CPU.Decoder.rs1, core.CPU.Decoder.rs2, core.CPU.Decoder.rd, core.CPU.Decoder.imm12);
        $display("\t     rs1 value=[%x] rs2 value=[%x]\n", core.CPU.rf_rs1_data, core.CPU.rf_rs2_data);
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
