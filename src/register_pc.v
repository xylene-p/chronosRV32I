module register_pc(q, valid, d, en, clk, rst);

  output reg [31:0] q;
  output reg        valid;
  input      [31:0] d;
  input             en, clk, rst;

  initial begin
    q <= 32'b0;
    valid <= 1'b0;
  end

  always @(posedge clk or negedge rst) begin
      if (rst == 0) begin
        q <= 32'b0;
        valid <= 1'b1;
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
