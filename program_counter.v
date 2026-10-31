module Program_Counter (
    input clk,                      // Clock
    input reset,                    // Reset

    output reg [4:0] pc             // Program Counter                                  5 bits
);

    // Run EITHER if the clock is high, or if reset is high
    always @(posedge clk or posedge reset) begin
        if(reset)
            pc <= 5'b00000; // Reset to the first instruction
        else
            pc <= pc + 1;   // Increment
    end
    
endmodule
