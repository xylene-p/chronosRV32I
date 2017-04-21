module EXMEMRegister(				// comment : not done; 
//output
	ALUOUT_out; 
	RS2_out;
	RS1_out; 
	//controls to WB
	wb_sel_out; 
	register_write_enable_out; 
	//controls to MEM
	mem_rw_out; 
	mem_val_out; 
	wb_sel_out; 
//input
	ALUOUT_in; 
	RS2_in;
	RS1_in;  
	clk; 
	rst; 
	en; 
	///controls to WB
	wb_sel_in; 
	register_write_enable_in; 
	//controls to MEM
	mem_rw_in; 
	mem_val_in; 
	wb_sel_in; 
	);

endmodule 