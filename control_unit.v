module Control_Unit (
    input clk,                      // Clock
    
    input [7:0] instr,              // Instruction                                      8 bits

    output reg sub,                 // Subtraction signal for ALU
    output reg[2:0] op_select,      // Operation select for ALU                         3 bits
    output reg write_enable,        // Write enable for OR
    output reg read_enable,         // Read enable for OR
    output reg [4:0] output_index,  // Index for OR                                     5 bits
    output reg halted//,              // Program halted
    //output reg load                 // Load "Address" into the ACC
);

    // Always run
    always @(*) begin
        // Default values
        op_select       = 3'b000;
        sub             = 0;
        write_enable    = 0;            // Default to 0 to prevent and unwanted writes
        read_enable     = 0;            // Default to 0 to prevent uninteded reads
        output_index    = 5'b00000;
        halted          = 0;

        // I feel like the opcode for ADD should be changed, since it defaults to add

        // DECODE

        /*
            Instruction     Opcode
            ADD             0000        0
            SUB             0001        1
            MULT            0100        4
            DIV             0101        5
            OUTPUT          0110        6
            OUTPUT_READ     0111        7
            LDA             1000        8
            HLT             1111        F
        */

        case(instr[7:4]) // 4-bit Opcode
            4'b0000: begin
                op_select = 3'b000; // ADD
                $display("ADD selected");
            end
            4'b0001: begin
                op_select = 3'b001; // SUB
                sub = 1;
                $display("SUB selected");
            end
            4'b0100: begin
                op_select = 3'b100; // MULT
                $display("MULT selected");
            end
            4'b0101: begin
                op_select = 3'b101; // DIV
                $display("DIV selected");
            end
            4'b0110: begin
                // OUTPUT instruction, writes result to OR
                write_enable = 1;           // Enable write
                output_index = instr[4:0];  // Use bits [4:0] as the index in the OR
                $display("OUTPUT selected");
            end
            4'b0111: begin
                // OUTPUT_READ instruction, outputting the stored value from the OR
                read_enable = 1;            // Enable read
                output_index = instr[4:0];  // Use bits [4:0] as the index to read from the OR
                $display("OUTPUT_READ selected");
            end
            4'b1000: begin
                // Load a value into the ACC
                op_select = 3'b110;
            end
            4'b1111: begin
                // End the program
                halted = 1;
                op_select = 3'b111;
                //$display("Program halted");
            end
            default: begin
                // Do nothing
            end
        endcase
    end
    
endmodule
