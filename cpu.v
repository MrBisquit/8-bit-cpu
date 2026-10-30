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
    wire [15:0] instr;               // Current instruction                             16 bits
    wire [7:0] data;                // Operand from the DR                              8 bits
    wire [7:0] acc_value;           // Accumulator value                                8 bits
    wire       sub;                 // Subtraction symbol ???
    wire [2:0] op_select;           // Operation select symbol                          3 bits
    wire [3:0] addr;                // Address for DR                                   4 bits
    wire [4:0] output_index;        // Index in the OR                                  4 bits
    wire       write_enable;        // Enable writing to the OR
    wire       read_enable;         // Enable reading from the OR
    wire [7:0] result;              // Result from the ALU                              8 bits

    // PC
    Program_Counter pc (
        .clk(clk),                          // clk              -> clk
        .reset(reset),                      // reset            -> reset
        .pc(program_counter)                // pc               -> program_counter
    );

    // IR (FETCH)
    Instruction_Register ir (
        .clk(clk),                          // clk              -> clk
        .load(load),                        // load             -> load
        .is_instr(is_instr),                // is_instr         -> is_instr
        .load_addr(load_addr),              // load_addr        -> load_addr
        .cpu_input(cpu_input),              // cpu_input        -> cpu_input
        .program_counter(program_counter),  // program_counter  -> program_counter
        .instr(instr)                       // instr            -> instr
    );

    // AR (extracts the address from the instruction)
    Address_Register ar (
        .instr(instr),                      // instr            -> instr
        .addr(addr)                         // addr             -> addr
    );

    // DR (fetches data from the address provided by the instruction)
    Data_Register dr (
        .clk(clk),                          // clk              -> clk
        .load(load),                        // load             -> load
        .is_instr(is_instr),                // is_instr         -> is_instr
        .load_addr(load_addr),              // load_addr        -> load_addr
        .cpu_input(cpu_input),              // cpu_input        -> cpu_input
        .addr(addr),                        // addr             -> addr
        .data(data)                         // data             -> data
    );

    // CU (DECODE) (decodes the instruction and generates the control signals for the ALU and OR)
    Control_Unit cu (
        .clk(clk),                          // clk              -> clk
        .instr(instr),                      // instr            -> instr
        .sub(sub),                          // sub              -> sub
        .op_select(op_select),              // op_select        -> op_select
        .write_enable(write_enable),        // write_enable     -> write_enable
        .read_enable(read_enable),          // read_enable      -> read_enable
        .output_index(output_index)         // output_index     -> output_index
    );

    // ACC (stores the result of the ALU and provides one of the Operands for the next operation)
    Accumulator acc (
        .clk(clk),                          // clk              -> clk
        .reset(reset),                      // reset            -> reset
        .alu_result(result),                // alu_result       -> result
        .acc_value(acc_value)               // acc_value        -> acc_value
    );

    // ALU (EXECUTE) (performs the arithmetic or logic operations based on the control signals)
    ALU alu (
        .a(acc_value),                      // a                -> acc_value
        .b(data),                           // b                -> data
        .sub(sub),                          // sub              -> sub
        .op_select(op_select),              // op_select        -> op_select
        .result(result),                    // result           -> result
        .cout(),                            // cout             -> (empty, unused)
        .overflow(),                        // overflow         -> (empty, unused)
        .negative(),                        // negative         -> (empty, unused)
        .zero()                             // zero             -> (empty, unused)
    );

    // OR
    Output_Register or (
        .clk(clk),                          // clk              -> clk
        .acc_value(acc_value),              // acc_value        -> acc_value
        .output_index(output_index),        // output_index     -> output_index
        .write_enable(write_enable),        // write_enable     -> write_enable
        .read_enable(read_enable),          // read_enable      -> read_enable
        .output_value(output_value)         // output_value     -> output_value
    );
    
endmodule