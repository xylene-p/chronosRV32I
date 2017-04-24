// 2 to 1 Multiplexer Module
// Author: Katherine Perez

module mux_2_1(out, in1, in2, sel);
    output [31:0] out;
    input  [31:0] in1;
    input  [31:0] in2;
    input sel;
    assign out = sel ? in2 : in1; // if true then in2 
endmodule
