// Chronos Instruction Memory

module inst_mem(
  // outputs
  request_data,
  // inputs
<<<<<<< HEAD
  fetch_addr, fetch_req, clk
  );

  output reg [31:0] request_data;
  input      [31:0] fetch_addr;
  input             fetch_req;
  input             clk;
=======
  address, clk, rst, wb_en, wb_address, wb_data 
  );

  output reg [31:0] request_data;
  input      [31:0] address;
  input             clk, rst;
  input wb_en;
  input [31:0] wb_address, wb_data;
>>>>>>> 4002fce60f4e14ebde5ff3e070288a770b7d939d


  reg [31:0] memory [0:20];
  reg [29:0] inst_addr;

  initial begin
    $readmemh("beq.hex", memory);
  end
  always @(*) begin
<<<<<<< HEAD
    inst_addr <= fetch_addr[31:2];
    if (fetch_req == 1'b1) begin
      request_data <= memory[inst_addr];
    end
    else begin
      request_data <= 32'hxxxxxxxx;
    end
=======
   // inst_addr <= address[31:2];
    request_data <= memory[address[31:2]];
  end

  always@(posedge clk) begin
    if(wb_en== 1) begin
      memory[wb_address] = wb_data; 
      end
>>>>>>> 4002fce60f4e14ebde5ff3e070288a770b7d939d
  end

endmodule
