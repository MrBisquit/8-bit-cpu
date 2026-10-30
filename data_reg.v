module Data_Register (
    input clk,                      // Clock
    input load,                     // Unified load signal

    input is_instr,                 // Selector, differenciates between instructions and data

    input [3:0] load_addr,          // Address to load instruction                      5 bits
    input [7:0] cpu_input,          // Input for loading both instructions and data     8 bits
    input [3:0] addr,               // Address to fetch the Operand                     4 bits

    output reg [7:0] data           // Operand data                                     8 bits
);

    reg [7:0] memory [15:0]; // 16 locations of 8-bit memory

    // When the clock goes up
    always @(posedge clk) begin
        // Only run if the signal is given to load, and the data is not an instruction
        if(load && !is_instr) begin
            // Load the data into the specified address
            memory[load_addr[3:0]] <= cpu_input;
        end
    end

    // Always run
    always @(*) begin
        // Fetch the data from the data memory
        data = memory[addr];
    end
    
endmodule