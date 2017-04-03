module two_stage_tb;

reg clk, rst;

reg addr;

wire [31:0] inst;

chronos_core RISCVCore(inst, addr, clk, rst);

always begin
    clk <= 0;
    #5 clk <= 1;
end

endmodule
