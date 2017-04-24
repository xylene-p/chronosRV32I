// Chronos Instruction Memory

module inst_mem(
  // outputs
  request_data,
  // inputs
  fetch_addr, fetch_req, clk, rst
  );

  output reg [31:0] request_data;
  input      [31:0] fetch_addr;
  input             fetch_req;
  input             clk;

  reg [31:0] memory [0:20];

  reg [29:0] inst_addr;

  initial begin
    $readmemh("beq.hex", memory);
  end

  always @(*) begin
    inst_addr <= fetch_addr[31:2];
    if (fetch_req == 1'b1) begin
      request_data <= memory[inst_addr];
    end
    else begin
      request_data <= 32'hxxxxxxxx;
    end
  end

endmodule
