module Control_Unit (
    input clk,                      // Clock
    
    input [15:0] instr,             // Instruction                                      16 bits

    output reg sub,                 // Subtraction signal for ALU
    output reg[2:0] op_select,      // Operation select for ALU                         3 bits
    output reg write_enable,        // Write enable for OR
    output reg read_enable,         // Read enable for OR
    output reg [4:0] output_index   // Index for OR                                     5 bits
);

    // Always run
    always @(*) begin
        // Default values
        op_select       = 3'b000;
        sub             = 0;
        write_enable    = 0;            // Default to 0 to prevent and unwanted writes
        read_enable     = 0;            // Defautl to 0 to prevent uninteded reads
        output_index    = 5'b00000;

        // I feel like the opcode for ADD should be changed, since it defaults to add

        // DECODE

        /*
            Instruction     Opcode
            ADD             0000
            SUB             0001
            MULT            0100
            DIV             0101
            OUTPUT          0110
            OUTPUT_READ     0111
        */

        case(instr[15:12]) // 4-bit Opcode
            4'b0000: begin
                op_select = 3'b000; // ADD
            end
            4'b0001: begin
                op_select = 3'b001; // SUB
                sub = 1;
            end
            4'b0100: begin
                op_select = 3'b100; // MULT
            end
            4'b0101: begin
                op_select = 3'b101; // DIV
            end
            4'b0110: begin
                // OUTPUT instruction, writes result to OR
                write_enable = 1;           // Enable write
                output_index = instr[4:0];  // Use bits [4:0] as the index in the OR
            end
            4'b0111: begin
                // OUTPUT_READ instruction, outputting the stored value from the OR
                read_enable = 1;            // Enable read
                output_index = instr[4:0];  // Use bits [4:0] as the index to read from the OR
            end
            default: begin
                // Do nothing
            end
        endcase
    end
    
endmodule
