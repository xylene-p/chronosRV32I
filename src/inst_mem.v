// Chronos Instruction Memory

module inst_mem(
  // outputs
  request_data,
  // inputs
  address, clk, rst, wb_en, wb_address, wb_data 
  );

  output reg [31:0] request_data;
  input      [31:0] address;
  input             clk, rst;
  input wb_en;
  input [31:0] wb_address, wb_data;


  reg [31:0] memory [0:20];
  reg [29:0] inst_addr;

  initial begin
    $readmemh("beq.hex", memory);
  end
  always @(*) begin
   // inst_addr <= address[31:2];
    request_data <= memory[address[31:2]];
  end

  always@(posedge clk) begin
    if(wb_en== 1) begin
      memory[wb_address] = wb_data; 
      end
  end

endmodule
