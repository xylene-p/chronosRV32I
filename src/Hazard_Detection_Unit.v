module Hazard_Detection_Unit(
	//output
	PC_write, 
	IFID_write,
	Mux_select, 
	//inputs
	IFID_Reg_Rs,
	IFID_Reg_Rd, 
	IDEX_MemRead, 
	IDEX_Reg_Rd
	);

output reg PC_write, IFID_write, Mux_select; 
input [4:0] IFID_Reg_Rs, IFID_Reg_Rd, IDEX_Reg_Rd; 
input IDEX_MemRead; 


always@(IFID_Reg_Rs, IFID_Reg_Rd, IDEX_Reg_Rd, IDEX_MemRead)
begin
	if(IDEX_MemRead && (IDEX_Reg_Rd == IFID_Reg_Rs || IDEX_Reg_Rd == IFID_Reg_Rd))
	begin
		PC_write = 0; 
		IFID_write =0; 
		Mux_select = 1;
	end
	else begin
		PC_write =1; 
		IFID_write = 1;
		Mux_select = 0; 
	end
end
endmodule 