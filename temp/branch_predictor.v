// Chronos Branch Predictor
// Author: Katherine Perez

module branch_predictor(
    // outputs
    pred_target, prediction,
    // inputs
    correct_target, correct_pc4, current_pc4,
    clk, rst);

    output reg [31:0] pred_target;
    output reg prediction;
    input [31:0] correct_target, correct_pc4, current_pc4;
    input clk, rst;

    wire [3:0] index = current_pc4[5:2];
    wire [31:0] target;

    // Check if current pc+4 is in the branch target buffer
    prediction_table PredictionTable(target, index, correct_target);

    always @(posedge clk) begin
        if (rst == 0) begin
            prediction <= 0;
            pred_tgt <= 32'b0;
        end
        else begin
            // If the target was in the table, predict taken
            if (target) begin
                prediction <= 1;
                pred_target <= target;
            end
            // Predict not taken otherwise
            else begin
                prediction <= 0;
                pred_target <= correct_pc4;
            end
        end
    end

endmodule

module prediction_table(target, index, correct_target);

    output reg [31:0] target;
    input [3:0] index;
    reg [31:0] branch_target_buffer[15:0];

    always @(*) begin
        if (branch_target_buffer[index]) begin
            target <= branch_target_buffer[index];
        end
        else begin
            target <= 32'b0;
            branch_target_buffer[index] = correct_target;
        end
    end

endmodule
