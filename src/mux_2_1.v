// 2 to 1 Multiplexer Module
// Author: Katherine Perez

module mux_2_1(out, in1, in2, sel);
    parameter
        output_len = 32,
        input1_len = 32,
        input2_len = 32;
    output [output_len-1:0] out;
    input  [input1_len-1:0] in1;
    input  [input2_len-1:0] in2;
    input sel;
    assign out = sel ? in2 : in1;
endmodule
