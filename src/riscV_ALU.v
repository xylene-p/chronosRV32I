module riscV_ALU(in_A, in_B, alu_Fx, Output, Zer0);
  input  [31:0]in_A, in_B;
  input  [3:0]alu_Fx;
  output [31:0]Output;
  output Zer0;
  reg    [31:0]Out;
  reg    ZeroP;
  
  always @(*) begin

          case (alu_Fx)
            4'b0000 : begin
                     Out   = in_A + in_B;                              //ADD  x
                     ZeroP = 0;
            end            
            4'b0001 : begin
                     Out = in_A << in_B;                               //SLL  x
                     ZeroP = 0;
            end            
            4'b0010 : begin
                     Out = {31'b0, $signed(in_A) < $signed(in_B)};     //SLT  x
                     ZeroP = Out;
            end            
            4'b0011 : begin
                     Out = {31'b0, in_A < in_B};                       //SLTU x
                     ZeroP = Out;
            end            
            4'b0100 : begin
                     Out = in_A ^ in_B;                               //XOR  x
                     ZeroP = 0;
            end            
            4'b0101 : begin
                     Out = in_A >> in_B;                              //SRL  x
                     ZeroP = 0;
            end            
            4'b0110 : begin
                     Out = in_A | in_B;                               //OR   x
                     ZeroP = 0;
            end            
            4'b0111 : begin
                     Out = in_A & in_B;                               //AND  x
                     ZeroP = 0;
            end            
            4'b1000 : begin
                     Out = {31'b0, in_A == in_B};                     //SEQ
                     ZeroP = Out;
            end            
            4'b1001 : begin
                     Out = {31'b0, in_A != in_B};                     //SNE
                     ZeroP = Out;
            end            
            4'b1010 : begin
                     Out = in_A - in_B;                               //SUB
                     ZeroP = 0;
            end            
            4'b1011 : begin
                     Out = $signed(in_A) >>> in_B;                    //SRA
                     ZeroP = 0;
            end            
            4'b1100 : begin
                     Out = {31'b0, $signed(in_A) >= $signed(in_B)};   //SGE
                     ZeroP = Out;
            end            
            4'b1101 : begin
                     Out = {31'b0, in_A >= in_B};                     //SGEU
                     ZeroP = Out;
            end            
            default : begin
                    Out = 31'b0;
                    ZeroP = 0;
            end                
      endcase // end case
      
   end//end always
   
      assign Output = Out;
      assign Zer0   = ZeroP;
endmodule
