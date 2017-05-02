module ChronosCore(
	input clk,
	input rst, 
	input en, 
	input [31:0] nop, 
	input [2:0] pc_sel_in); 



/// IFID STAGE
// PC_sel ? from where 
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
wire [6:0] opcode_wire, funct7_wire; 
wire reg_write_en_wire, mem_req_write_wire, mem_req_type_wire; 
wire [2:0] wb_sel_wire; 
decode_control control_decoder(
	//outputs 
    .rs1(rs1_wire),
    .rs2(rs2_wire),
    .rd(rd_wire),
    .opcode(opcode_wire),
    .reg_write_en(reg_write_en_wire),
    .wb_sel(wb_sel_wire),
    .mem_req_write(mem_req_write_wire),
    .mem_req_type(mem_req_type_wire),
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
    .register_write(instruction_rd_out_MEMWB_wire), // need to come from wb stage
    .write_data(wb_data_out_MEMWB_wire), 
    .register_write_enable(register_write_enable_out_MEMWB_wire)); 

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
    .regIDEX_rd(IDEXRegRead_out_IDEX_wire),
    .memReadIDEX(IDEXMemRead_IDEX_wire));


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
    .rs2_in(rs2_wire), 
    .rd_in(rd_wire), 
    .reg_write_en_in(reg_write_en_wire), 
    .wb_sel_in(wb_sel_wire), 
    .mem_req_write_in(mem_req_write_wire), 
    .mem_req_type_in(mem_req_type_wire),
    .kill_DEC(ID_kill_wire),
    .nop(nop));

wire [3:0] alu_sel_mux; 
mux_2_1 #(4) alu_decode_mux(
    .out(alu_sel_mux),
    .in1(alu_sel_wire),
    .in2(nop[3:0]),
    .sel(ID_kill));


wire [31:0] pc4_out_IDEX_wire;
wire [31:0] pc_out_IDEX_wire;
wire [31:0] inst_out_IDEX_wire;
wire [31:0] operand1_out_IDEX_wire;
wire [31:0] operand2_out_IDEX_wire;
wire [4:0] instruction_rd_out_IDEX_wire;
wire prediction_out_IDEX_wire;
//controls to WB
wire register_write_enable_out_IDEX_wire;
//controls to MEM
wire mem_request_write_out_IDEX_wire;
wire mem_request_type_out_IDEX_wire;
//control to EXE
wire [3:0] alu_sel_out_IDEX_wire;
wire [2:0] wb_sel_out_IDEX_wire;
//HazardControlUnit outputs
wire [4:0] IDEXRegRead_out_IDEX_wire;
wire IDEXMemRead_IDEX_wire;
wire [4:0] rs2_out_IDEX_wire;
register_IDEX stageIDEX(
	//outputs
	.pc4_out(pc4_out_IDEX_wire),
	.pc_out(pc_out_IDEX_wire),
	.inst_out(inst_out_IDEX_wire),
	.operand1_out(operand1_out_IDEX_wire),
	.operand2_out(operand2_out_IDEX_wire),
	.instruction_rd_out(instruction_rd_out_IDEX_wire),
	.prediction_out(prediction_out_IDEX_wire),
	//controls to WB
	.register_write_enable_out(register_write_enable_out_IDEX_wire),
	//controls to MEM
	.mem_request_write_out(mem_request_write_out_IDEX_wire),
	.mem_request_type_out(mem_request_type_out_IDEX_wire),
	//control to EXE
	.alu_sel_out(alu_sel_out_IDEX_wire),
	.wb_sel_out(wb_sel_out_IDEX_wire),
	//HazardControlUnit outputs
	.IDEXRegRead_out(IDEXRegRead_out_IDEX_wire),
	.IDEXMemRead(IDEXMemRead_IDEX_wire),
	.rs2_out(rs2_out_IDEX_wire),
	//inputs 
    .clk(clk),
    .rst(rst),
    .en(en),
    .pc4_in(pc4_out_wire),
    .pc_in(pc_out_wire),
    .inst_in(instruction_wire),
    .operand1_in(op1_wire),
    .operand2_in(op2_wire),
    .instruction_rd_in(rd_wire),
    .rs2_in(rs2_wire),
    .prediction_in(0),
    //controls to WB
    .register_write_enable_in(reg_write_en_mux),
    //controls to MEM
    .mem_request_write_in(mem_req_write_mux),
    .mem_request_type_in(mem_req_type_mux),
    //control to EXE
    .alu_sel_in(alu_sel_mux),
    .wb_sel_in(wb_sel_mux)); 

//EXMEM STAGE
wire [31:0] alu_out_wire; 
alu _alu(
	.alu_out(alu_out_wire),
	.op1(operand1_out_IDEX_wire),
	.op2(operand2_out_IDEX_wire),
	.alu_sel(alu_sel_out_IDEX_wire)); 

wire [31:0] branch_target_wire;
wire branch_taken_wire;
branch_gen _branch_gen(
	.branch_target(branch_target_wire), 
	.branch_taken(branch_taken_wire), 
	.inst(inst_out_IDEX_wire),
	.pc(pc4_out_IDEX_wire),
	.alu_out(alu_out_wire)); 

branch_predictor _branch_predictor(
	.clk(clk),
	.rst(rst), 
	.correct_target(), 
	.correct_pc4(), 
	.current_pc4()); 

wire [31:0] PC44_out_wire;
add_const #(4) pc4Next(
	.out(PC44_out_wire),
	.in(pc4_out_IDEX_wire)); 

wire [31:0] ALUOUT; 
mux_2_1 #(32) _wb_sel_mux(
	.out(ALUOUT), 
	.in1(PC44_out_wire),
	.in2(alu_out_wire),
	.sel(1));

wire [31:0] alu_out_EXMEM_wire;
wire [4:0] rs2_out_EXMEM_wire;
wire [4:0] instruction_rd_out_EXMEM_wire;
wire [31:0] instruction_out_EXMEM_wire; 
//controls to WB
wire register_write_enable_out_EXMEM_wire;
//controls to MEM
wire mem_request_write_out_EXMEM_wire;
wire mem_request_type_out_EXMEM_wire;
wire [2:0] wb_sel_out_EXMEM_wire;
register_EXMEM stageEXMEM(
	//outputs
	.alu_out(alu_out_EXMEM_wire),
	.rs2_out(rs2_out_EXMEM_wire),
	.instruction_rd_out(instruction_rd_out_EXMEM_wire),
	.instruction_out(instruction_out_EXMEM_wire),
	//controls to WB
	.register_write_enable_out(register_write_enable_out_EXMEM_wire),
	//controls to MEM
	.mem_request_write_out(mem_request_write_out_EXMEM_wire), //
	.mem_request_type_out(mem_request_type_out_EXMEM_wire), ///
	.wb_sel_out(wb_sel_out_EXMEM_wire),
	//inputs -- 
	.alu_out_in(ALUOUT),
	.rs2_in(rs2_out_IDEX_wire),
	.instruction_rd_in(instruction_rd_out_IDEX_wire),
	.instruction_in(inst_out_IDEX_wire), 
	.clk(clk),
	.rst(rst),
	.en(en),
	//controls to WB
	.register_write_enable_in(register_write_enable_out_IDEX_wire),
	//controls to MEM
	.mem_request_write_in(mem_request_write_out_IDEX_wire),
	.mem_request_type_in(mem_request_type_out_IDEX_wire),
	.wb_sel_in(wb_sel_out_IDEX_wire)
	); 

//MEMWB stage

wire [31:0] output_data_mux_wire;
writeback _writeback(
	.output_data(output_data_mux_wire), 
	.out_data_mem(data_memory_output_data_wire), 
	.out_alu(alu_out_EXMEM_wire), 
	.wb_sel(wb_sel_out_EXMEM_wire)); 


wire [31:0] data_memory_output_data_wire;
wire [31:0] memory_addr_wire;
wire [31:0] write_data_wire;//
wire [3:0] write_mask_wire;
wire cmd_wire;   
data_memory _data_memory(
	.memory_addr(memory_addr_wire), //output
	.write_data(write_data_wire), 
	.write_mask(write_mask_wire), 
	.output_data(data_memory_output_data_wire),
	.instruction(instruction_out_EXMEM_wire), 
	.data(rs2_out_EXMEM_wire), 
	.addr(alu_out_EXMEM_wire), 
	.load_data(load_data_wire)); 

wire [31:0] load_data_wire;
wire valid_wire; //
simulated_mem _simulated_mem(
	.load_data(load_data_wire), 
	.valid(valid_wire),
	.clk(clk),
	.reset(rst), 
	.addr(memory_addr_wire), 
	.mask(write_mask_wire), 
	.enable(en), 
	.cmd(cmd_wire), 
	.write_data(write_data_wire)); //


wire [31:0] wb_data_out_MEMWB_wire;
wire [4:0] instruction_rd_out_MEMWB_wire;
wire register_write_enable_out_MEMWB_wire;
register_MEMWB _register_MEMWB(
	.wb_data_out(wb_data_out_MEMWB_wire), 
	.instruction_rd_out(instruction_rd_out_MEMWB_wire), 
	.register_write_enable_out(register_write_enable_out_MEMWB_wire), 
	.wb_data_in(output_data_mux_wire), 
	.instruction_rd_in(instruction_rd_out_EXMEM_wire), 
	.clk(clk), 
	.rst(rst), 
	.en(en),
	.register_write_enable_in(register_write_enable_out_EXMEM_wire));


// register_file _register_file(
// 	.register_write(),  
// 	.write_data(), 
// 	.register_write_enable()); 




endmodule 