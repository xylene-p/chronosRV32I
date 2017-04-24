module stage_IDEX(); 
reg clk, rst, en; 
reg [31:0] instruction;
reg [31:0] pc4;  
initial begin

	$dumpfile("idex_dump.vcd"); 
	$dumpvars();
	$display("test for IDEX stage, are the correct values latching"); 

    $display("ALU DECODER"); 
	$monitor("ALU DECODER\nINST:[%h] op1:[%h] op2:[%h] alu_sel:[%h]\nCONTROL DECODER\nOPCODE:[%b] RD:[%b] wb_sel:[%b]", 
        instruction,
        alu_decoder.op1,
        alu_decoder.op2,
        alu_decoder.alu_sel,
        control_decoder.opcode,
        control_decoder.rd,
        control_decoder.wb_sel); 

	clk <= 1'b1; 
	rst<= 1; 
	en<=1; 

    pc4 = 32'h4; 
	instruction = 32'h00000013;
    #10 pc4 = 32'h8; 
	#10 instruction = 32'h00200513;
    #20 pc4 = 32'hc; 
	#20 instruction = 32'h00200593;
	#100
	$finish; 
end

wire [31:0] data1; 
wire [31:0] data2; 
register_file reg_file(
    .read_data_1(data1), 
    .read_data_2(data2),
    .rs_1(rs1), 
    .rs_2(rs2),
    .register_write(0), 
    .write_data(0), 
    .register_write_enable(0)); 

wire[3:0] alu_sel;
wire[31:0] op1, op2; 
decode_alu alu_decoder(
    .op1(op1),
    .op2(op2),
    .alu_sel(alu_sel),
    .inst(instruction),
    .rs1(data1),
    .rs2(data2));

wire [4:0] rs1, rs2, rd; 
wire [6:0] opcode; 
wire reg_write_en, mem_req_write, mem_req_type; 
wire [2:0] wb_sel; 
decode_control control_decoder(
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),
    .opcode(opcode),
    .reg_write_en(reg_write_en),
    .wb_sel(wb_sel),
    .mem_req_write(mem_req_write),
    .mem_req_type(mem_req_type),
    .inst(instruction));

wire IF_kill, ID_kill; 
hazard_detect HDU(
    .kill_IF(IF_kill),
    .kill_DEC(ID_kill),
    .regIFID_rs1(rs1),
    .regIFID_rs2(rs2),
    .regIFID_rd(rd),
    .regIDEX_rd(0),
    .memReadIDEX(0));

mux_2_1 IDKill(
    .out(),
    .in1(),
    .in2(nop),
    .sel(kill_DEC));






endmodule 