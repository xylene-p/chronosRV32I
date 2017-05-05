module register_pc(q, d, en, clk, rst);

  output reg [31:0] q;
  input      [31:0] d;
  input             en, clk, rst;

  initial begin
    q <= 32'b0;
  end

  always @(posedge clk or negedge rst) begin
      if (rst == 0) begin
        q <= 32'b0;
      end
      else if (en == 1) begin
        q <= d;
      end
      else begin
        q <= 32'hxxxxxxxx;
      end
  end
endmodule
