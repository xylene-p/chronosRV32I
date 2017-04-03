// Chronos Register

module register(q, valid, d, en, clk, rst);

  output [31:0] q;
  output valid;
  input  [31:0] d;
  input en, clk, rst;

  always @(posedge clk or negedge rst) begin
      if (~rst) begin
        q <= 32'b0;
        valid <= 1'b0;
      end
      else if (en == 1) begin
        q <= d;
        valid <= 1'b1;
      end
      else begin
        q <= 32'hxxxxxxxx;
        valid <= 1'b0;
      end
  end

endmodule
