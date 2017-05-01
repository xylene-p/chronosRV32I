module ChronosCore(
	input clk,
	input rst, 
	input en); 



/// IFID STAGE
wire [31:0] mux_address_out; 
mux_4_1 PCMUX(
    .pc_next(mux_address_out),
    .pc_sel(pc_sel_in),
    .curr_pc4(PCNext_out),
    .branch(),
	.predicted_target());

wire [31:0] PCReg_out; 
register_pc PCReg(
    .q(PCReg_out),
    .d(mux_address_out),
    .en(en),
    .clk(clk),
    .rst(rst));

wire [31:0] Instruction; 
inst_mem InstMem(
    .request_data(Instruction),
    .address(PCReg_out),
    .clk(clk),
    .rst(rst),
    .wb_en(0), 
    .wb_address(32'b0), 
    .wb_data(32'b0));

wire [31:0] PCNext_out;
add_const #(4) PCNext(
	.out(PCNext_out),
	.in(PCReg_out)); 


wire [31:0] pc4_out_wire; 
wire [31:0] pc_out_wire; 
wire [31:0] instruction_wire; 
wire prediction_out_wire; 
register_IFID stageIFID(
    .pc4_out(pc4_out_wire),
    .pc_out(pc4_out_wire),
    .instruction_out(instruction_wire),
    .prediction_out(prediction_out_wire),
    .pc4_in(PCNext_out),
    .pc_in(PCReg_out),
    .instruction_in(Instruction),
    .prediction_in(0),
    .clk(clk),
    .rst(rst),
    .en(en));


// IDEX STAGE  				//pull data from IFID register 
wire [4:0] rs1_wire, rs2_wire, rd_wire; 
wire [6:0] opcode; 
wire reg_write_en, mem_req_write, mem_req_type; 
wire [2:0] wb_sel; 
decode_control control_decoder(
	//outputs 
    .rs1(rs1_wire),
    .rs2(rs2_wire),
    .rd(rd_wire),
    .opcode(opcode),
    .reg_write_en(reg_write_en),
    .wb_sel(wb_sel),
    .mem_req_write(mem_req_write),
    .mem_req_type(mem_req_type),
    //inputs
    .inst(instruction_wire));  // from IFID

wire [31:0] data1_wire; 
wire [31:0] data2_wire; 
register_file reg_file(
	//outputs
    .read_data_1(data1_wire), 
    .read_data_2(data2_wire),
    //inputs
    .rs_1(rs1_wire), 
    .rs_2(rs2_wire),
    .register_write(0), // need to come from wb stage
    .write_data(0), 
    .register_write_enable(0)); 

wire[3:0] alu_sel_wire;
wire[31:0] op1_wire, op2_wire; 
decode_alu alu_decoder(
	//outputs
    .op1(op1_wire),
    .op2(op2_wire),
    .alu_sel(alu_sel_wire),
    //inputs
    .inst(instruction_wire),
    .rs1(data1_wire),
    .rs2(data2_wire));

wire IF_kill_wire, ID_kill_wure; 
hazard_detect HDU(
	//outputs
    .kill_IF(IF_kill_wire),
    .kill_DEC(ID_kill_wire),
    //inputs
    .regIFID_rs1(rs1_wire),
    .regIFID_rs2(rs2_wire),
    .regIFID_rd(rd_wire),
    .regIDEX_rd(0), //end of the IDEX latch
    .memReadIDEX(0)); //end of the IDEX latch


//FUCK 
wire [4:0] rs2_mux, rd_mux;
wire reg_write_en_mux, mem_req_write_mux, mem_req_type_mux;
wire [2:0] wb_sel_mux; 
decode_mux mux_decode(
	//outputs
    .rs2_out(rs2_mux),
    .rd_out(rd_mux),
    .reg_write_en_out(reg_write_en_mux), 
    .wb_sel_out(wb_sel_mux), 
    .mem_req_write_out(mem_req_write_mux), 
    .mem_req_type_out(mem_req_type_mux),
    //inputs 
    .rs2_in(rs2), 
    .rd_in(rd), 
    .reg_write_en_in(reg_write_en), 
    .wb_sel_in(wb_sel), 
    .mem_req_write_in(mem_req_write), 
    .mem_req_type_in(mem_req_type),
    .kill_DEC(ID_kill),
    .nop(nop));

wire [3:0] alu_sel_mux; 
mux_2_1 #(4) alu_decode_mux(
    .out(alu_sel_mux),
    .in1(alu_sel),
    .in2(nop[3:0]),
    .sel(ID_kill));

register_IDEX stageIDEX(
    .clk(clk),
    .rst(rst),
    .en(en),
    .pc4_in(pc4),
    .pc_in(pc),
    .inst_in(instruction),
    .operand1_in(op1),
    .operand2_in(op2),
    .instruction_rd_in(rd_mux),
    .rs2_in(rs2_mux),
    .prediction_in(0),
    //controls to WB
    .register_write_enable_in(reg_write_en_mux),
    //controls to MEM
    .mem_request_write_in(mem_req_write_mux),
    .mem_request_type_in(mem_req_type_mux),
    //control to EXE
    .alu_sel_in(alu_sel_mux),
    .wb_sel_in(wb_sel_mux)); 

endmodule 