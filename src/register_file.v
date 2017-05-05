module register_file(
    output [31:0] rs1_data,
    output [31:0] rs2_data,
    input [4:0] rs_1,
    input [4:0] rs_2,
    input [4:0] register_write,
    input [31:0] write_data,
    input register_write_enable);

    parameter num_regs = 32;
    reg [31:0] registers[0:num_regs-1];

    initial begin
        $readmemh("data.hex", registers); 
    end

    always @(register_write or write_data) begin
        if(register_write_enable)
            registers[register_write] <= write_data;
    end
<<<<<<< HEAD

    assign rs1_data = rs_1 == 0 ? 32'b0 : registers[rs_1];
    assign rs2_data = rs_2 == 0 ? 32'b0 : registers[rs_2];
=======
    assign read_data_1 = rs_1 == 0 ? 32'b0 : registers[rs_1];
    assign read_data_2 = rs_2 == 0 ? 32'b0 : registers[rs_2];
>>>>>>> 4002fce60f4e14ebde5ff3e070288a770b7d939d
endmodule


