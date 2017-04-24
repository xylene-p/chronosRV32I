// 4 to 1 Multiplexer
// Author: Katherine Perez

`include "defines.vh"

module mux_4_1(
    output reg [31:0] pc_next,
    input [2:0] pc_sel,
    input [31:0] curr_pc4,
    input [31:0] branch,
    input [31:0] corr_pc4,
    input [31:0] predicted_target);

    always @(*) begin
        case (pc_sel)
            `PCMUX_CURR_PC4:
                pc_next <= curr_pc4;
            `PCMUX_HAZARD:
                pc_next <= pc_next;
            `PCMUX_BRANCH:
                pc_next <= branch;
            `PCMUX_CORR_PC4:
                pc_next <= corr_pc4;
            `PCMUX_PRED_TGT:
                pc_next <= predicted_target;
            default:
                pc_next <= curr_pc4;
        endcase
    end

endmodule
