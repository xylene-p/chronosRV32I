`timescale 1ns/1ns

module IFStage_tb();

  reg clk = 0, rst;
  reg en;

  wire [31:0] request_data;
  wire        fetch_data_valid;

  integer i;

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

    en = 1;

    #(cycle);
    rst = 0;
    #(cycle);
    rst = 1;
    #(cycle);

    while (i < timeout) begin
      #(cycle);
      i = i + 1;
      $display("C %10d: pc=[%08x]",
				          i, core.PCReg.d);
    end

    if (i == timeout) begin
			$display("*** TIMEOUT ***");
			$finish();
		end

    $finish();

  end

endmodule
