// Chronos Instruction Memory

module inst_mem(
  // outputs
  request_data, fetch_data_valid,
  // inputs
  fetch_addr, fetch_req, clk, rst
  );

  output reg [31:0] request_data;
  output reg        fetch_data_valid;
  input      [31:0] fetch_addr;
  input             fetch_req;
  input             clk, rst;

  reg [31:0] memory [0:20];

  reg [29:0] inst_addr;

  initial begin
    $readmemh("beq.hex", memory);
  end

  always @(*) begin
    inst_addr <= fetch_addr[31:2];
    if (fetch_req == 1'b1) begin
      request_data <= memory[inst_addr];
      fetch_data_valid <= 1'b1;
    end
    else begin
      request_data <= 32'hxxxxxxxx;
      fetch_data_valid <= 1'b0;
    end
  end

endmodule
