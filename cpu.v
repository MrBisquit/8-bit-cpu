module cpu (
    input clk,                      // Clock
    input reset,                    // Reset

    input [7:0] cpu_input,          // Shared input for both instructions and data      8 bits
    input [4:0] load_addr,          // Address to load instruction                      5 bits
    input load,                     // Load signal
    input is_instr,                 // Selector, differenciates between instructions and data
    output [7:0] output_val         // Output register value on wire
);

    // DR = Data Register
    // OR = Output Register
    wire [4:0] program_counter;     // PC value                                         5 bits
    wire [7:0] instr;               // Current instruction                              8 bits
    wire [7:0] data;                // Operand from the DR                              8 bits
    wire [7:0] acc_value;           // Accumulator value                                8 bits
    wire       sub;                 // Subtraction symbol ???
    wire [2:0] op_select;           // Operation select symbol                          3 bits
    wire [3:0] addr;                // Address for DR                                   4 bits
    wire [4:0] output_index;        // Index in the OR                                  4 bits
    wire       write_enable;        // Enable writing to the OR
    wire       read_enable;         // Enable reading from the OR
    wire [7:0] result;              // Result from the ALU                              8 bits

    // Program Counter
    Program_Counter pc (
        .clk(clk),                          // clk              -> clk
        .reset(reset),                      // reset            -> reset
        .pc(program_counter)                // pc               -> program_counter
    );

    // Instruction Register (FETCH)
    Instruction_Register ir (
        .clk(clk),                          // clk              -> clk
        .load(load),                        // load             -> load
        .is_istr(is_instr),                 // is_instr         -> is_instr
        .load_addr(load_addr),              // load_addr        -> load_addr
        .cpu_input(cpu_input),              // cpu_input        -> cpu_input
        .program_counter(program_counter),  // program_counter  -> program_counter
        .instr(instr)                       // instr            -> instr
    );
    
endmodule