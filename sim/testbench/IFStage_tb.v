module IFStage_tb;

  reg clk, rst;
  reg en;

  wire [31:0] request_data;
  wire        fetch_data_valid;

  integer i;

  IFStage core(
    .request_data(request_data),
    .fetch_data_valid(fetch_data_valid),
    .en(en),
    .clk(clk),
    .rst(rst),
    );

  initial clk = 0;
	parameter half_cycle = 5;
	localparam cycle = 2 * half_cycle;
	localparam timeout = 100;

	always #(half_cycle) clk = ~clk;

  initial begin
    $dumpvars()

    #(cycle);
    reset = 0;
    #(cycle);
    reset = 1;
    #(cycle);

    while (i < timeout) begin
      #(cycle);
      i = i + 1;
      $display("C %10d: pc=[%08x]",
				          i, IFStage.PCReg.d);
    end

    if (i == timeout) begin
			$display("*** TIMEOUT ***");
			$finish();
		end

    $finish();

  end

endmodule
