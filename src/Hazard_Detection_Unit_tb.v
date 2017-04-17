`include "riscv_defines.v"
`include "Hazard_Detection_Unit.v"

module Hazard_Detection_Unit_tb();

reg [4:0] IFID_WRITE_RS, IFID_WRITE_RD, IDEX_WRITE_RD; 
reg IDEX_MEMWRITE; 

wire PC_READ, IFID_READ, MUX_SELECT_READ; 


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
	);

initial begin

	$display("Testing if returns PASSED for a hazard");
	// 1st inst register access rd- x1F
	// 2nd inst register access rs- x1F , x1B
	IDEX_WRITE_RD = 5'b0;
	IFID_WRITE_RS = 5'b0;
	IFID_WRITE_RD = 5'b0;
	IDEX_MEMWRITE = 1'b1;
	#100;
	$display("%b, %b, %b, %b", IDEX_WRITE_RD, IFID_WRITE_RS, IFID_WRITE_RD, IDEX_MEMWRITE);
	if(PC_READ == 0 && IFID_READ == 0 && MUX_SELECT_READ == 1) begin
		$display("PASSED");
	end
	else begin
		$display("FAILED");
	end
	$display("PC_READ - %d \t IFID_READ - %d \t MUX_SELECT_READ - %d",
			_firstTestInstance.PC_write,
			_firstTestInstance.IFID_write,
			_firstTestInstance.Mux_select);
    $finish;
end

endmodule