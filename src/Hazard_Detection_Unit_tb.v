`include riscv_defines.v
`include Hazard_Detection_Unit.v

module Hazard_Detection_Unit_tb();

wire [4:0] IFID_WRITE_RS, IFID_WRITE_RD, IDEX_MEMWRITE; 
wire IDEX_MEMWRITE; 

reg PC_READ; IFID_READ; MUX_SELECT_READ; 


	// //output
	// PC_write, 
	// IFID_write,
	// Mux_select, 
	// //inputs
	// IFID_Reg_Rs,
	// IFID_Reg_Rd, 
	// IDEX_MemRead, 
	// IDEX_Reg_Rd
Hazard_Detection_Unit _firstTestInstance(
	.PC_write(PC_READ), 
	.IFID_write(IFID_READ), 
	.Mux_select(MUX_SELECT_READ), 
	.IFID_Reg_Rs(IFID_WRITE_RS),
	.IFID_Reg_Rd(IFID_WRITE_RD),
	.IDEX_MemRead(IDEX_MEMWRITE),
	.IDEX_Reg_Rd(IDEX_WRITE_RD)
	)

initial begin
	$display("");
	
end

endmodule