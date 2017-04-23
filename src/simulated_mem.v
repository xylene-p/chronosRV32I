module simulated_mem (
	input clk,
	input reset,

	input [31:0] addr,
	input [3:0] mask,
	input enable,

	input cmd,
	input [31:0] write_data,
	output reg [31:0] load_data,
	output reg valid
);
	localparam MEMORY_SIZE = (1 << 14);
	reg [31:0] memory [MEMORY_SIZE - 1:0];
	wire [29:0] word_addr = addr[31:2];


	always @ (*) begin
		if (enable && cmd == `MEM_CMD_READ) begin
			load_data = memory[word_addr];
			valid = 1;
		end else begin
			load_data = 32'b0;
			valid = 0;
		end
	end

	wire [31:0] expanded_mask = {mask[3] ? 8'hFF : 8'h00,
	                             mask[2] ? 8'hFF : 8'h00,
	                             mask[1] ? 8'hFF : 8'h00,
	                             mask[0] ? 8'hFF : 8'h00};

	wire [31:0] to_be_written = (memory[word_addr] & ~expanded_mask) | (write_data & expanded_mask);

	always @ (*) begin
		if (enable && cmd == `MEM_CMD_WRITE) begin
			memory[word_addr] = to_be_written;
		end
	end

endmodule
