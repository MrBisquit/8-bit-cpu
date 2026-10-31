module Instruction_Register (
    input clk,                      // Clock
    input load,                     // Unified load signal

    input is_instr,                 // Selector, differenciates between instructions and data

    input [4:0] load_addr,          // Address to load instruction                      5 bits
    input [7:0] cpu_input,          // Input for loading both instructions and data     8 bits
    input [4:0] program_counter,    // Current instruction address                      5 bits

    output reg [7:0] instr          // 8-bit instruction    Opcode + Operand Address    8 bits
);

    reg [7:0] instrs [31:0];        // 32 instructions, all 8 bits wide

    // When the clock goes up
    always @(posedge clk) begin
        // Only run if the signal is given to load, and the data is an instruction
        if (load && is_instr) begin
            // Load the instruction into the specified address
            instrs[load_addr] <= cpu_input;
        end
    end

    // Always run
    always @(*) begin
        // Fetch the instruction from the instruction memory
        // (FETCH) DECODE EXECUTE
        instr = instrs[program_counter];
    end
    
endmodule
