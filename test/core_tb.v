`timescale 1ns/1ns

`include "defines.vh"

module Core_tb();

  reg clk = 0, rst;
  reg en, pc_sel;
  reg [31:0] nop;

  wire [4:0] rs1, rs2;

  integer i = 0;

  ChronosCore core(
    .rs1(rs1),
    .rs2(rs2),
    .en(en),
    .clk(clk),
    .rst(rst),
    .nop(nop),
    .pc_sel(pc_sel));

  parameter half_cycle = 5;
  localparam cycle = 2 * half_cycle;
  localparam timeout = 100;

  always #(half_cycle) clk = ~clk;

  initial begin
    $dumpvars();
    nop <= `INST_NOP;
    pc_sel <= 1;
    en <= 1;

    rst <= 0;
    #(cycle);
    #(cycle);
    rst <= 1;

    while (i < timeout) begin
      $display("Cycle %5d: pc=[%08x] inst_fetch=[%08x] rs1=[%x] rs2=[%x] rd=[%x]",
				   i, core.PCReg.q, core.Decoder.inst, core.rs1, core.rs2, core.rd);
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
