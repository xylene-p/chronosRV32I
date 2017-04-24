module register_file(
    output [31:0] read_data_1,
    output [31:0] read_data_2,
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
    assign read_data_1 = rs_1 == 0 ? 32'b0 : registers[rs_1];
    assign read_data_2 = rs_2 == 0 ? 32'b0 : registers[rs_2];
endmodule


