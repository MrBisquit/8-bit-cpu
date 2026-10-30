module Accumulator (
    input clk,                      // Clock
    input reset,                    // Reset

    input [7:0] alu_result,         // Result from the ALU                              8 bits

    output reg [7:0] acc_value      // Accumulator value                                8 bits
);

    // Run either when clk goes high, or when reset goes high
    always @(posedge clk or posedge reset) begin
        if (reset)
            acc_value <= 8'b0; // Reset the ACC
        else
            acc_value <= alu_result; // Store the ALU result in the ACC
    end
    
endmodule