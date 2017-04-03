// Chronos Add Constant Register

module add_const(out, in);

  parameter const_val = 1;

  output [31:0] out;
  input  [31:0] in;

  assign out = in + const_val;

endmodule
