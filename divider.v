module Divider (
    input [7:0] dividend,           // First input                                      8 bits
    input [7:0] divisor,            // Second input                                     8 bits

    output reg [7:0] quotient,      // Quotient                                         8 bits
    output reg [7:0] remainder      // Remainder                                        8 bits
);

    // Always run
    always @(*) begin
        // Protect from 0 / 0
        if(divisor != 0) begin
            quotient = dividend / divisor;
            remainder = dividend % divisor;
        end else begin
            quotient = 8'hFF;   // Indicate division by zero
            remainder = 8'hFF;  // Indicate division by zero
        end
    end
    
endmodule