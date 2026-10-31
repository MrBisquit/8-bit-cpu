/* verilator lint_off WIDTHEXPAND */

module Address_Register (
    input [7:0] instr,              // Instruction                                      8 bits
    output reg [3:0] addr           // The address for the Operand                      4 bits
);

    // Always run
    always @(*) begin
        assign addr = instr[3:3]; // Address for the Operand
    end
    
endmodule
