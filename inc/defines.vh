// ChronosRV32I Defines
// Derived from RISC-V Instruction Set Manual v2.1
// Chapter 9 - RV32/64 G Instruction Set Listings

`ifndef defines_vh
`define defines_vh

`define INST_NOP 32'h13

// OPCODES
// R-Type Instructions
`define OPCODE_OP	    7'b0110011
// I-Type Instructions
`define OPCODE_OP_IMM 	7'b0010011
`define OPCODE_LUI	    7'b0110111
`define OPCODE_LOAD	    7'b0000011
// S-Type Instructions
`define OPCODE_STORE	7'b0100011
// U-Type Instructions
`define OPCODE_J	    7'b1100111
`define OPCODE_JAL	    7'b1101111
`define OPCODE_JALR	    7'b1101011
`define OPCODE_BRANCH	7'b1100011
// System Call Instructions
`define OPCODE_SYS      7'b1111011

// [R-Type] funct3
`define F3_ADD		3'b000
`define F3_SLL		3'b001
`define F3_SLT		3'b010
`define F3_SLTU		3'b011
`define F3_XOR		3'b100
`define F3_SR		3'b101
`define F3_OR		3'b110
`define F3_AND		3'b111

// [SB-Type] funct3
`define F3_BEQ		3'b000
`define F3_BNE		3'b001
`define F3_BLT		3'b100
`define F3_BGE		3'b101
`define F3_BLTU		3'b110
`define F3_BGEU		3'b111

// Write Back Select
`define WB_ALU		3'b001
`define WB_MEM		3'b010
`define WB_PC4		3'b011
`define WB_SYS		3'b100

// ALU Functions
`define ALU_ADD 	4'd0
`define ALU_SLL		4'd1
`define ALU_SLT		4'd2
`define ALU_SLTU	4'd3
`define ALU_XOR		4'd4
`define ALU_SRL		4'd5
`define ALU_SRA		4'd6
`define ALU_OR		4'd7
`define ALU_AND		4'd8
// Multiplication not in use
// `define ALU_MUL		4'd9
// `define ALU_DIV		4'd10
// `define ALU_DIVU	4'd11
// `define ALU_REM		4'd12
// `define ALU_REMU	4'd13
`define ALU_LUI		4'd14
`define ALU_NONE	4'd15

// Memory Request Types
`define MEM_REQ_READ	1'b0
`define MEM_REQ_WRITE	1'b1
// Memory Command Types
`define MEM_CMD_READ	1'b0
`define MEM_CMD_WRITE	1'b1

// Load and Store Funct3 Types
`define F3_LB		3'b000 /*Load Byte*/
`define F3_LH		3'b001 /*Load Half Word*/
`define F3_LW		3'b010 /*Load Word*/

`define F3_SB		3'b000 /*Store Byte*/
`define F3_SH		3'b001 /*Store Half Word*/
`define F3_SW		3'b010 /*Store Word*/

`endif
