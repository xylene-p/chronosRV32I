// Chronos Instruction Memory

module inst_mem(
  // outputs
  request_data, fetch_data_valid,
  // inputs
  fetch_addr, fetch_req, clk, rst
  );

  output [31:0] request_data;
  output        fetch_data_valid;
  input  [31:0] fetch_addr;
  input         fetch_req;
  input         clk, rst;

  reg [31:0] memory [0:5];

  initial begin
    $readmemh("mem.hex", memory);
  end

  always @(*) begin
    if (rst == 1'b0) begin
      $readmemh("mem.hex", memory);
    end
    else if (fetch_req == 1'b1) begin
      request_data <= memory[fetch_addr];
      fetch_data_valid <= 1'b1;
    end
    else begin
      request_data <= 32'hxxxxxxxx;
      fetch_data_valid <= 1'b0;
    end
  end

endmodule
