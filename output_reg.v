module Output_Register (
    input clk,                      // Clock

    input [7:0] acc_value,          // The value from the ACC                           8 bits
    input [4:0] output_index,       // Index from the OR                                5 bits
    input write_enable,             // Write enable signal
    input read_enable,              // Read enable signal

    output reg [7:0] output_value   // Output wire to send the result
);

    reg [7:0] memory [31:0];        // Memory, 32 places                                8 bits

    // When the clock goes high
    always @(posedge clk) begin
        // Only run if the write signal is high
        if(write_enable) begin
            // Write the ACC value to the specified index in the OR
            memory[output_index] <= acc_value;
        end
    end

    // Always run
    always @(*) begin
        // Only run if the read signal is high
        if(read_enable) begin
            // Output the value stored in the specified index of the OR
            output_value = memory[output_index];
        end
    end
    
endmodule