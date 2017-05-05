// 2 to 1 Multiplexer Module
// Author: Katherine Perez

module mux_2_1(out, in1, in2, sel);
	parameter size = 2; 
    output [size-1:0] out;
    input  [size-1:0] in1;
    input  [size-1:0] in2;
    input sel;
    assign out = sel ? in2 : in1; // if true then in2 
endmodule
