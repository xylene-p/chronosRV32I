`timescale 1ns/1ns

module IFStage_tb();

  reg clk = 0, rst;
  reg en;

  wire [31:0] request_data;
  wire        fetch_data_valid;

  integer i = 0;

  IFStage core(
    .request_data(request_data),
    .fetch_data_valid(fetch_data_valid),
    .en(en),
    .clk(clk),
    .rst(rst)
    );

  parameter half_cycle = 5;
  localparam cycle = 2 * half_cycle;
  localparam timeout = 100;

  always #(half_cycle) clk = ~clk;

  initial begin
    $dumpvars();

    rst = 0;
    #(cycle);
    rst = 1;
    en = 1;

    while (i < timeout) begin
      $display("Cycle %5d: pc=[%08x] inst_fetch=[%08x]",
				          i, core.PCReg.q, core.request_data);
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
