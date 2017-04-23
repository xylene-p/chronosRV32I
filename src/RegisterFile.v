// Register File
// Author: Katherine Perez

module RegisterFile(
    //output
    Read_Data2, 
    Read_Data1,
    //intput
    Register_Source1, 
    Register_Source2, 
    Register_Write, 
    Write_RegisterData 
    Register_Write_enable); // from control function 

    parameter num_regs = 32;
    reg [31:0] registers[num_regs-1:0];

    output [31:0] Read_Data1, Read_Data2;
    input  [4:0]  Register_Source1, Register_Source2, Register_Write;
    input  [31:0] Write_RegisterData;

    always @(Register_Write or Write_RegisterData) begin 
        if(Register_Write_enable)
            registers[Register_Write] <= Write_RegisterData;
    end
    // needs testing 

    assign Read_Data1 = Register_Source1 == 0 ? 32'b0 : registers[Register_Source1];
    assign Read_Data2 = Register_Source2 == 0 ? 32'b0 : registers[Register_Source2];

endmodule
